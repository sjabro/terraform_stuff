variable "vpc_cidr" {
  type        = string
  description = "CIDR for the the VPC"
  default = "172.16.0.0/16"
}

variable "vpc_names" {
    type = list(string)
    default = ["vpc_name_1","vpc_name_2"]
}

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

    for_each = var.vpc_names
    tags = {
      "Name" = each.value
      "Usage" = "Morpheus Testing"
    }
}

output "aws_vpc" {
  value = aws_vpc.vpc
}