################################################################################
# VPC Module
################################################################################
variable "vpc_cidr" {
  type        = string
  description = "CIDR for the the VPC"
  default = "172.16.0.0/16"
}

variable "vpc_names" {
    type = list(string)
    default = ["vpc_name_1","vpc_name_2"]
}

locals {
  vpc_count = {for u in var.vpc_names: index(var.vpc_names, u) => u}
  time = formatdate("MM-DD-YYYY", timestamp())
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  for_each = local.vpc_count
  name = "${each.value}_${local.time}"
  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = []
  public_subnets  = [cidrsubnet(var.vpc_cidr, 4, each.key)]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = false

  public_subnet_tags = {
    "Name" = "${each.value}_subnet"
  }

  tags = {
    Deployed = local.time
    Student = each.value
  }

  vpc_tags = {
    "Name" = "${each.value}_${local.time}"
  }
}