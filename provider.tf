provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

provider "kubernetes" {
  host                   = module.eks.eks_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_cluster_ca_certificate)
  token                  = module.eks.eks_token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.eks_endpoint
    cluster_ca_certificate = base64decode(module.eks.eks_cluster_ca_certificate)
    token                  = module.eks.eks_token
  }
}


#Em caso de replicação de ambientes por exemplo (staging, production ...) basta criar vários providers kubernetes e helm usando alias para cada um deles
# por exemplo: 

# provider "kubernetes" {
#   alias                  = "staging"
#   host                   = module.eks(ambiente).eks_endpoint
#   cluster_ca_certificate = base64decode(module.eks(ambiente).eks_cluster_ca_certificate)
#   token                  = module.eks(ambiente).eks_token
# }
# provider "kubernetes" {
#   alias                  = "production"
#   host                   = module.eks(ambiente).eks_endpoint
#   cluster_ca_certificate = base64decode(module.eks(ambiente).eks_cluster_ca_certificate)
#   token                  = module.eks(ambiente).eks_token
# }

# Alterando claro os valores de host, cluster_ca_certificate e token para cada um dos ambientes. 
# O deploy no module seria assim:
# module "netflix-deployment" {
#   source   = "./modules/k8s_deployment/"
#   provider = kubernetes.staging
#    .....

# module "netflix-deployment" {
#   source   = "./modules/k8s_deployment/"
#   provider = kubernetes.production
#    .....
