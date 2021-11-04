################################################################################
# VPC Vars
################################################################################
variable "vpc_root_cidr" {
    type = string
    default = "172.30.0.0/24"
}

################################################################################
# VPC Configuration
################################################################################

resource "aws_vpc" "main" {
  cidr_block = var.vpc_root_cidr

  tags = {
    "Name" = "Morpheus Platform VPC"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "Morpheus Platform IGW"
  }

  depends_on = [
    aws_vpc.main
  ]
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "Morpheus Platform Route Table"
  }
}

resource "aws_route" "main" {
  route_table_id = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id

  depends_on = [
    aws_route_table.main
  ]
}

resource "aws_route_table_association" "public_subnets" {
  for_each = local.az_map

  subnet_id = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.main.id
}

resource "aws_subnet" "public_subnets" {
  for_each = local.az_map 
  vpc_id = aws_vpc.main.id
  availability_zone = each.value
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, each.key) 

  tags = {
    "Name" = "Morpheus Public Subnet: ${each.value}"
  }

  depends_on = [
    aws_vpc.main
  ]
}

# resource "aws_subnet" "private_subnets" {
#   for_each = local.az_map
#   vpc_id = aws_vpc.main.id
#   availability_zone = each.value 
#   cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, each.key + 3)

#     tags = {
#     "Name" = "Morpheus Private Subnet: ${each.value}"
#   }

#   depends_on = [
#     aws_vpc.main
#   ]
# }

# resource "aws_subnet" "database_subnets" {
#   for_each = local.az_map
#   vpc_id = aws_vpc.main.id
#   availability_zone = each.value
#   cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, each.key + 6)

#     tags = {
#     "Name" = "Morpheus Database Subnet: ${each.value}"
#   }

#   depends_on = [
#     aws_vpc.main
#   ]
# }