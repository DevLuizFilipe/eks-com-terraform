#Cria uma VPC com duas subnetes privadas que utiliza um NAT gateway e uma publica que utiliza um internet gateway
module "vpc" {
  source                   = "./modules/vpc/"
  vpc_name                 = "vpc-netflix"
  vpc_cidr_block           = "192.168.0.0/16"
  vpc_subnet_private_count = "2"
  vpc_subnet_public_count  = "2"
  vpc_subnet_regions       = "us-east-1a,us-east-1b"
}

#Cria um IAM role para o EKS e cria uma role para o Node Group
module "iam" {
  source                       = "./modules/iam/"
  iam_role_eks_name            = "iam-eks"
  iam_role_eks_node_group_name = "iam-eks-node-group"
}

#Cria um cluster EKS com duas subnetes e um Node Group com duas instancias
module "eks" {
  source                         = "./modules/eks/"
  eks_name                       = "netflix"
  eks_role_arn                   = module.iam.role_eks_arn
  eks_control_plane_version      = "1.27" #Alterar não indispõe as aplicações versões: https://docs.aws.amazon.com/eks/latest/userguide/platform-versions.html
  eks_subnets_id                 = module.vpc.subnet_private_id
  eks_security_group_id          = [module.vpc.security_group_id]
  eks_enviroment_tag             = "production"
  eks_node_group_version         = "1.27" #Alterar indispõe as aplicações (Boa prática atualizar fora do horário comercial)
  eks_node_group_name            = "apps"
  eks_node_group_role_arn        = module.iam.role_eks_node_group_arn
  eks_nodegroup_desired_instance = "4"
  eks_nodegroup_max_instance     = "5"
  eks_nodegroup_min_instance     = "2"
  eks_nodegroup_instance_type    = ["t2.medium"]
  eks_nodegroup_instance_disk    = "20"
  depends_on                     = [module.vpc, module.iam]
}

# #Cria um dominio e um record do tipo CNAME   (Foi Criado na Digital Ocean)
# module "route53" {
#   source              = "./modules/route53/"
#   route53_zone_name   = "labluizfilipe.com.br"
#   route53_record_name = "netflix"
#   route53_record_type = "CNAME"
#   route53_record_ttl  = "15"
#   route53_records     = ["ad3f84cb53d294f9c80b2ee8465ac1d3-818998528.us-east-1.elb.amazonaws.com"] #Alterar
# }

#Cria um nginx ingress controler do tipo Load Balancer e cria uma service account com permissões admin
module "nginx-ingress-controler" {
  source                              = "./modules/k8s_nginx_ingress_controller/"
  nginx_ingress_controller_name       = "nginx-ingress-controller"
  nginx_ingress_controller_namespace  = "kube-system"
  nginx_ingress_controller_repository = "https://kubernetes.github.io/ingress-nginx"
  nginx_ingress_controller_chart      = "ingress-nginx"
  depends_on                          = [module.eks]
}

#Cria um namespace para o netflix
module "netflix-namespace" {
  source         = "./modules/k8s_namespace/"
  namespace_name = "netflix"
  depends_on     = [module.eks]
}

#Cria um service para o netflix
module "netflix-service" {
  source              = "./modules/k8s_service/"
  service_name        = "netflix-service"
  service_namespace   = module.netflix-namespace.namespace_name
  service_selector    = module.netflix-deployment.deployment_name
  service_type        = "ClusterIP"
  service_protocol    = "TCP"
  service_port        = "80"
  service_target_port = module.netflix-deployment.deployment_container_port
  depends_on          = [module.netflix-namespace]
}

#Cria um ingress para a aplicação netflix
module "netflix-ingress" {
  source                       = "./modules/k8s_ingress/"
  ingress_name                 = "netflix-ingress"
  ingress_namespace            = module.netflix-namespace.namespace_name
  ingress_host                 = "netflix.labluizfilipe.com"
  ingress_path                 = "/"
  ingress_backend_service_name = module.netflix-service.service_name
  ingress_backend_service_port = module.netflix-service.service_port
  depends_on                   = [module.netflix-namespace, module.netflix-service]
}

#Cria um deployment para a aplicação netflix
module "netflix-deployment" {
  source                          = "./modules/k8s_deployment/"
  deployment_name                 = "netflix-deployment"
  deployment_namespace            = module.netflix-namespace.namespace_name
  deployment_replicas             = "2"
  deployment_container_name       = "netflix-container"
  deployment_container_image_name = "luizfilipesm/netflix-copy"
  deployment_container_image_tag  = "0.0.2"
  deployment_container_port       = "3000"
  depends_on                      = [module.netflix-namespace]
}

#Cria um namespace para o newrelic
module "newrelic-namespace" {
  source         = "./modules/k8s_namespace/"
  namespace_name = "newrelic"
  depends_on     = [module.eks]
}

# module "newrelic-agent" {
#   source                            = "./modules/k8s_newrelic_agent/"
#   newrelic_agent_name               = "newrelic-bundle"
#   newrelic_agent_repository         = "https://helm-charts.newrelic.com"
#   newrelic_agent_chart              = "nri-bundle"
#   newrelic_agent_namespace          = module.newrelic-namespace.namespace_name
#   newrelic_agent_license_key        = "insira seu token"
#   newrelic_agent_cluster            = "netflix"
#   newrelic_agent_image_tag          = "2.7.0"
#   newrelic_agent_pixie_api_key      = "insira seu token"
#   newrelic_agent_pixie_deploy_key   = "insira seu token"
#   newrelic_agent_pixie_cluster_name = module.newrelic-agent.newrelic_agent_cluster
#   depends_on                        = [module.newrelic-namespace]
# }
