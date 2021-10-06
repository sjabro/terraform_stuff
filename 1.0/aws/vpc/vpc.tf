variable "vpc_cidr" {
  type        = string
  description = "CIDR for the the VPC"
  default = "172.16.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "Name for the VPC"
  default = "demo"
}

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

    tags = {
      "Name" = var.vpc_name
      "Usage" = "Morpheus Testing"
    }
}

output "aws_vpc" {
  value = aws_vpc.vpc
}