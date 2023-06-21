provider "kubernetes" {
  alias                  = "staging"
  host                   = module.eks_staging.eks_endpoint
  cluster_ca_certificate = base64decode(module.eks_staging.eks_cluster_ca_certificate)
  token                  = module.eks_staging.eks_token
}

provider "helm" {
  alias = "staging"
  kubernetes {
    host                   = module.eks_staging.eks_endpoint
    cluster_ca_certificate = base64decode(module.eks_staging.eks_cluster_ca_certificate)
    token                  = module.eks_staging.eks_token
  }
}

#Cria um nginx ingress controler do tipo Load Balancer
module "nginx_ingress_controler_staging" {
  source                              = "./modules/k8s_nginx_ingress_controller/"
  nginx_ingress_controller_name       = "nginx-ingress-controller"
  nginx_ingress_controller_namespace  = "kube-system"
  nginx_ingress_controller_repository = "https://kubernetes.github.io/ingress-nginx"
  nginx_ingress_controller_chart      = "ingress-nginx"
  depends_on                          = [module.eks_staging]
}

#Cria um namespace para o netflix
module "netflix_namespace_staging" {
  source         = "./modules/k8s_namespace/"
  namespace_name = "netflix"
  depends_on     = [module.eks_staging, module.nginx_ingress_controler_staging]
}

#Cria um service para o netflix
module "netflix_service_staging" {
  source              = "./modules/k8s_service/"
  service_name        = "netflix-service"
  service_namespace   = module.netflix_namespace_staging.namespace_name
  service_selector    = module.netflix_deployment_staging.deployment_name
  service_type        = "LoadBalancer" #Alterar para ClusterIP
  service_protocol    = "TCP"
  service_port        = "80"
  service_target_port = module.netflix_deployment_staging.deployment_container_port
  depends_on          = [module.netflix_namespace_staging, module.netflix_deployment_staging]
}

#Cria um ingress para a aplicação netflix
module "netflix_ingress_staging" {
  source                       = "./modules/k8s_ingress/"
  ingress_name                 = "netflix-ingress"
  ingress_namespace            = module.netflix_namespace_staging.namespace_name
  ingress_host                 = "netflix.labluizfilipe.com"
  ingress_path                 = "/"
  ingress_backend_service_name = module.netflix_service_staging.service_name
  ingress_backend_service_port = module.netflix_service_staging.service_port
  depends_on                   = [module.netflix_namespace_staging, module.netflix_service_staging, module.newrelic_agent_staging]
}

#Cria um deployment para a aplicação netflix
module "netflix_deployment_staging" {
  source                          = "./modules/k8s_deployment/"
  deployment_name                 = "netflix-deployment"
  deployment_namespace            = module.netflix_namespace_staging.namespace_name
  deployment_replicas             = "2"
  deployment_container_name       = "netflix-container"
  deployment_container_image_name = "luizfilipesm/netflix-copy"
  deployment_container_image_tag  = "0.0.2"
  deployment_container_port       = "3000"
  depends_on                      = [module.netflix_namespace_staging]
}

#Cria um namespace para o newrelic
module "newrelic_namespace_staging" {
  source         = "./modules/k8s_namespace/"
  namespace_name = "newrelic"
  depends_on     = [module.eks_staging]
}

module "newrelic_agent_staging" {
  source                            = "./modules/k8s_newrelic_agent/"
  newrelic_agent_name               = "newrelic-bundle"
  newrelic_agent_repository         = "https://helm-charts.newrelic.com"
  newrelic_agent_chart              = "nri-bundle"
  newrelic_agent_namespace          = module.newrelic_namespace_staging.namespace_name
  newrelic_agent_license_key        = "insira seu token"
  newrelic_agent_cluster            = "netflix"
  newrelic_agent_image_tag          = "2.7.0"
  newrelic_agent_pixie_api_key      = "insira seu token"
  newrelic_agent_pixie_deploy_key   = "insira seu token"
  newrelic_agent_pixie_cluster_name = module.newrelic_agent_staging.newrelic_agent_cluster
  depends_on                        = [module.newrelic_namespace_staging]
}
