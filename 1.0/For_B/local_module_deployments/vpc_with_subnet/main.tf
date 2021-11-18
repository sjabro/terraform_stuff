module "vpc" {
  source = "./vpc"

  name = var.vpc_name
  cidr = var.vpc_cidr

}