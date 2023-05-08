#Cria uma VPC com duas subnetes privadas que utiliza um NAT gateway e uma publica que utiliza um internet gateway
module "vpc" {
  source                     = "./modules/vpc/"
  vpc_name                   = "vpc-kube-news"
  vpc_cidr_block             = "10.0.0.0/16"
  vpc_subnet1_cidr_block     = "10.0.1.0/24"
  vpc_subnet2_cidr_block     = "10.0.2.0/24"
  vpc_subnet3_cidr_block     = "10.0.3.0/24"
  vpc_subnet_region1         = "us-east-1a"
  vpc_subnet_region2         = "us-east-1b"
  vpc_subnet_region3         = "us-east-1c"
  vpc_route_table_cidr_block = "0.0.0.0/0"
}

#Cria um IAM role para o EKS e cria uma role para o Node Group
module "iam" {
  source                       = "./modules/iam/"
  iam_role_eks_name            = "iam-eks"
  iam_role_eks_node_group_name = "iam-eks-node-group"
}

#Cria um cluster EKS com duas subnetes e um Node Group com duas instancias
module "eks-dev" {
  source                         = "./modules/eks/"
  eks_name                       = "kube-news"
  eks_role_arn                   = module.iam.role_eks_arn
  eks_subnets_id                 = [module.vpc.subnet1_id, module.vpc.subnet2_id]
  eks_enviroment_tag             = "production"
  eks_node_group_name            = "apps"
  eks_node_group_role_arn        = module.iam.role_eks_node_group_arn
  eks_nodegroup_desired_instance = "2"
  eks_nodegroup_max_instance     = "4"
  eks_nodegroup_min_instance     = "1"
  eks_nodegroup_instance_type    = ["t2.medium"]
  eks_nodegroup_instance_disk    = "20"
  depends_on                     = [module.vpc, module.iam]
}

#Cria um dominio e um record do tipo CNAME
module "route53" {
  source              = "./modules/route53/"
  route53_zone_name   = "labluizfilipe.io"
  route53_record_name = "kube-news"
  route53_record_type = "CNAME"
  route53_record_ttl  = "300"
  route53_records     = ["aeb5d77ebd1f74c1b98aa7ffc72c6cf4-1269572450.us-east-1.elb.amazonaws.com"]
}

#Cria um nginx ingress controler do tipo Load Balancer e cria uma service account com permissões admin
module "nginx-ingress-controler" {
  source                              = "./modules/k8s_nginx_ingress_controller/"
  nginx_ingress_controller_name       = "nginx-ingress-controller"
  nginx_ingress_controller_namespace  = "kube-system"
  nginx_ingress_controller_repository = "https://kubernetes.github.io/ingress-nginx"
  nginx_ingress_controller_chart      = "ingress-nginx"
  depends_on                          = [module.eks-dev]
}

#Cria um namespace para o kube-news
module "kube-news-namespace" {
  source         = "./modules/k8s_namespace/"
  namespace_name = "kube-news"
  depends_on     = [module.eks-dev]
}

#Cria um service para o kube-news
module "kube-news-service" {
  source              = "./modules/k8s_service/"
  service_name        = "kube-news-service"
  service_namespace   = module.kube-news-namespace.namespace_name
  service_selector    = module.kube-news-deployment.deployment_name
  service_type        = "ClusterIP"
  service_protocol    = "TCP"
  service_port        = "80"
  service_target_port = module.kube-news-deployment.deployment_container_port
  depends_on          = [module.kube-news-namespace]
}

#Cria um service para o postgres
module "postgres-service" {
  source              = "./modules/k8s_service/"
  service_name        = "postgres-service"
  service_namespace   = module.kube-news-namespace.namespace_name
  service_selector    = module.postgres-deployment.deployment_name
  service_type        = "ClusterIP"
  service_protocol    = "TCP"
  service_port        = "80"
  service_target_port = module.postgres-deployment.deployment_container_port
  depends_on          = [module.kube-news-namespace]
}

#Cria um ingress para a aplicação kube-news
module "kube-news-ingress" {
  source                       = "./modules/k8s_ingress/"
  ingress_name                 = "kube-news-ingress"
  ingress_namespace            = module.kube-news-namespace.namespace_name
  ingress_host                 = "kube-news.labluizfilipe.io"
  ingress_path                 = "/"
  ingress_backend_service_name = module.kube-news-service.service_name
  ingress_backend_service_port = module.kube-news-service.service_port
  depends_on                   = [module.kube-news-namespace, module.kube-news-service]
}

#Cria um deployment para a aplicação kube-news
module "kube-news-deployment" {
  source                          = "./modules/k8s_deployment/"
  deployment_name                 = "kube-news-deployment"
  deployment_namespace            = module.kube-news-namespace.namespace_name
  deployment_replicas             = "2"
  deployment_container_name       = "kube-news-container"
  deployment_container_image_name = "luizfilipesm/kube-news"
  deployment_container_image_tag  = "latest"
  deployment_container_port       = "80"
  deployment_secret_name          = module.secrets.secret_name_kube_news
  deployment_prometheus_monitore  = "true"
  deployment_prometheus_port      = module.kube-news-deployment.deployment_container_port
  deployment_prometheus_path      = "/metrics"
  depends_on                      = [module.kube-news-namespace]
}

#Cria um deployment para o postgres
module "postgres-deployment" {
  source                          = "./modules/k8s_deployment/"
  deployment_name                 = "postgres-deployment"
  deployment_namespace            = module.kube-news-namespace.namespace_name
  deployment_replicas             = "1"
  deployment_container_name       = "postgres-container"
  deployment_container_image_name = "postgres"
  deployment_container_image_tag  = "15"
  deployment_container_port       = "5432"
  deployment_secret_name          = module.secrets.secret_name_postgres
  deployment_prometheus_monitore  = "true"
  deployment_prometheus_port      = module.postgres-deployment.deployment_container_port
  deployment_prometheus_path      = "/metrics"
  depends_on                      = [module.kube-news-namespace]
}

#Cria um secret para o kube-news e Postgres
module "secrets" {
  source                = "./modules/k8s_secret/"
  secret_name_kube_news = "kube-news-secret"
  secret_name_postgres  = "postgres-secret"
  secret_namespace      = "kube-news"
  depends_on            = [module.eks-dev]
}
