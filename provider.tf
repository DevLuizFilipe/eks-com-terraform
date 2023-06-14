provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "arn:aws:eks:us-east-1:127298958182:cluster/netflix"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
