output "iam_access_key" {
  value = aws_iam_access_key.user_key
  sensitive = true
}

output "aws_instance" {
  value = aws_instance.app_node
}
