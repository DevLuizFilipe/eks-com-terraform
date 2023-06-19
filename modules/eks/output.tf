output "eks_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "eks_cluster_ca_certificate" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "eks_token" {
  value = data.aws_eks_cluster_auth.acess.token
}
