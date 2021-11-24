################################################################################
# VPC Vars
################################################################################
variable "vpc_root_cidr" {
    type = string
    default = "172.30.0.0/24"
    description = "This will be the CIDR assigned to your VPC AND your subnet."
}

################################################################################
# VPC Configuration
################################################################################

resource "aws_vpc" "main" {
  count = var.instance_count
  cidr_block = var.vpc_root_cidr

  tags = {
    "Name" = "mor-adm-${var.region}-${count.index}"
  }
}

resource "aws_internet_gateway" "main" {
  count = var.instance_count
  vpc_id = aws_vpc.main[count.index].id

  tags = {
    "Name" = "mor-adm-${var.region}-${count.index}"
  }

  depends_on = [
    aws_vpc.main
  ]
}

resource "aws_route_table" "main" {
  count = var.instance_count
  vpc_id = aws_vpc.main[count.index].id

  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.main
  ]

  tags = {
    "Name" = "mor-adm-${var.region}-${count.index}"
  }
}

resource "aws_route" "main" {
  count = var.instance_count
  route_table_id = aws_route_table.main[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main[count.index].id

  depends_on = [
    aws_route_table.main,
    aws_internet_gateway.main
  ]
}

resource "aws_route_table_association" "public_subnets" {
  count = var.instance_count

  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.main[count.index].id

  depends_on = [
    aws_subnet.public_subnets,
    aws_route_table.main,
    aws_internet_gateway.main
  ]

}

resource "aws_subnet" "public_subnets" {
  count = var.instance_count

  vpc_id = aws_vpc.main[count.index].id
  availability_zone = "${var.region}a"
  cidr_block = var.vpc_root_cidr 

  tags = {
    "Name" = "mor-adm-${var.region}-${count.index}"
  }

  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.main
  ]
}