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

variable "vpc_count" {
  type = number
  default = 1  
}

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

    count = var.vpc_count
    tags = {
      "Name" = "${var.vpc_name}_${count.index}"
      "Usage" = "Morpheus Testing"
    }
}

output "aws_vpc" {
  value = aws_vpc.vpc
}