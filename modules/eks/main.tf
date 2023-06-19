resource "aws_eks_cluster" "cluster" {
  name     = var.eks_name
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids         = var.eks_subnets_id
    security_group_ids = var.eks_security_group_id
  }

  tags = {
    Environment = var.eks_enviroment_tag
  }
}

data "aws_eks_cluster_auth" "acess" {
  name = aws_eks_cluster.cluster.name
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = var.eks_node_group_role_arn
  subnet_ids      = var.eks_subnets_id

  scaling_config {
    desired_size = var.eks_nodegroup_desired_instance
    max_size     = var.eks_nodegroup_max_instance
    min_size     = var.eks_nodegroup_min_instance
  }

  instance_types = var.eks_nodegroup_instance_type
  disk_size      = var.eks_nodegroup_instance_disk
}
