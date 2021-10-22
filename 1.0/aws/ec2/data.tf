data "aws_vpc" "main" {
    id = var.default_vpc_id
}

data "aws_subnet" "main" {
    id = var.default_subnet_id
}