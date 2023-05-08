output "role_eks_arn" {
  value = aws_iam_role.role_eks.arn
}

output "role_eks_node_group_arn" {
  value = aws_iam_role.role_eks_node_group.arn
}
