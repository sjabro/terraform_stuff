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
  for_each = local.student_list
  cidr_block = var.vpc_root_cidr

  tags = {
    "Name" = "${each.value}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  for_each = local.student_list
  vpc_id = aws_vpc.main[each.key].id

  tags = {
    "Name" = "${each.value}-igw"
  }

  depends_on = [
    aws_vpc.main
  ]
}

resource "aws_route_table" "main" {
  for_each = local.student_list
  vpc_id = aws_vpc.main[each.key].id

  tags = {
    "Name" = "${each.value}-rtb"
  }
}

resource "aws_route" "main" {
  for_each = local.student_list
  route_table_id = aws_route_table.main[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main[each.key].id

  depends_on = [
    aws_route_table.main
  ]
}

resource "aws_route_table_association" "public_subnets" {
  for_each = local.student_list

  subnet_id = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.main[each.key].id
}

resource "aws_subnet" "public_subnets" {
  for_each = local.student_list
  vpc_id = aws_vpc.main[each.key].id
  availability_zone = "${var.region}a"
  cidr_block = var.vpc_root_cidr 

  tags = {
    "Name" = "${each.value}-subnet"
  }

  depends_on = [
    aws_vpc.main
  ]
}