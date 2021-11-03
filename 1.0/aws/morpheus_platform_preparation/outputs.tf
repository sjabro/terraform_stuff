output "aws_vpc" {
  value = aws_vpc.main
}

output "public_subnets" {
  value = aws_subnet.public_subnets
}

output "private_subnets" {
  value = aws_subnet.private_subnets
}

output "database_subnets" {
  value = aws_subnet.database_subnets
}