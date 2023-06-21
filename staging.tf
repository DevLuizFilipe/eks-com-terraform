#Cria uma VPC com duas subnetes privadas que utiliza um NAT gateway e duas publica que utiliza um internet gateway.
module "vpc_staging" {
  source                   = "./modules/vpc/"
  vpc_name                 = "vpc-netflix-staging"
  vpc_cidr_block           = "10.0.0.0/16"
  vpc_subnet_private_count = "2"
  vpc_subnet_public_count  = "2"
  vpc_subnet_regions       = "us-east-1a,us-east-1b"
}

#Cria um IAM role para o EKS e cria uma role para o Node Group
module "iam_staging" {
  source                       = "./modules/iam/"
  iam_role_eks_name            = "iam-eks-staging"
  iam_role_eks_node_group_name = "iam-eks-node-group-staging"
}

#Cria um cluster EKS com duas subnetes e Node Group de acordo com a quantidade do count, os node groups serão identicos.
module "eks_staging" {
  source                         = "./modules/eks/"
  eks_name                       = "netflix-staging"
  eks_role_arn                   = module.iam_staging.role_eks_arn
  eks_control_plane_version      = "1.27" #Alterar não indispõe as aplicações versões: https://docs.aws.amazon.com/eks/latest/userguide/platform-versions.html
  eks_subnets_id                 = module.vpc_staging.subnet_private_id
  eks_security_group_id          = [module.vpc_staging.security_group_id]
  eks_enviroment_tag             = "staging"
  eks_node_group_count           = "1"
  eks_node_group_version         = "1.27" #Alterar indispõe as aplicações (Boa prática atualizar fora do horário comercial).
  eks_node_group_name            = "apps"
  eks_node_group_role_arn        = module.iam_staging.role_eks_node_group_arn
  eks_nodegroup_desired_instance = "4"
  eks_nodegroup_max_instance     = "5"
  eks_nodegroup_min_instance     = "2"
  eks_nodegroup_instance_type    = ["t2.medium"]
  eks_nodegroup_instance_disk    = "20"
  depends_on                     = [module.vpc_staging, module.iam_staging]
}

# #Cria um dominio e um record do tipo CNAME   (Foi Criado na Digital Ocean).
# module "route53" {
#   source              = "./modules/route53/"
#   route53_zone_name   = "labluizfilipe.com.br"
#   route53_record_name = "netflix"
#   route53_record_type = "CNAME"
#   route53_record_ttl  = "15"
#   route53_records     = ["ad3f84cb53d294f9c80b2ee8465ac1d3-818998528.us-east-1.elb.amazonaws.com"] #Alterar
# }
