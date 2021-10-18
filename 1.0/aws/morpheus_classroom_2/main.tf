################################################################################
# VPC Resource
################################################################################

resource "aws_vpc" "main" {
    for_each = local.student_count

    
    cidr_block = "${cidrsubnet(var.vpc_root_cidr, 4, each.key)}"

    tags = {
      Name = "${each.value}_${local.time}"
    }
}

################################################################################
# IGW Resource
################################################################################

resource "aws_internet_gateway" "main" {
    for_each = local.student_count
    vpc_id = aws_vpc.main[each.key].id

    tags = {
      Name = "${each.value}_${local.time}"
    }

    depends_on = [
      aws_vpc.main
    ]
}

################################################################################
# Subnet Resource
################################################################################

resource "aws_subnet" "main" {
    for_each = local.student_count
    vpc_id = aws_vpc.main[each.key].id

    cidr_block = "${cidrsubnet(var.vpc_root_cidr, 4, each.key)}"

    tags = {
      Name = "${each.value}_${local.time}"
    }

    depends_on = [
      aws_vpc.main
    ]
}
################################################################################
# Resource Security Group
################################################################################

resource "aws_security_group" "main" {
    for_each = local.student_count
    vpc_id = aws_vpc.main[each.key].id
    name = "${each.value}_${local.time}"

    tags = {
      Name = "${each.value}_${local.time}"
    }

}

# ################################################################################
# # IAM Module 
# ################################################################################

# module "iam_user" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-user"
#   version = "~> 4.3"

#   for_each = local.student_count
#   name          = each.value
#   force_destroy = true

#   create_iam_user_login_profile = false
#   create_iam_access_key         = true
# }

# ################################################################################
# # EC2 Module 
# ################################################################################

# module "ec2_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 3.0"

#   for_each = local.student_count

#   name = "instance-${each.value}"

#   ami                    = local.amis[var.region]
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [module.security-group[each.key].security_group_id]
#   subnet_id              = module.vpc[each.key].public_subnets[0]
#   associate_public_ip_address = true

#   tags = {
#     Terraform   = "true"
#     Environment = "training"
#     Student = each.value
#   }
# }

# module "morpheus_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 3.0"

#   for_each = local.student_count

#   name = "morpheus-${each.value}"

#   ami                    = local.amis[var.region]
#   instance_type          = "t2.large"
#   vpc_security_group_ids = [module.security-group[each.key].security_group_id]
#   subnet_id              = module.vpc[each.key].public_subnets[0]
#   associate_public_ip_address = true
  
#   tags = {
#     Terraform   = "true"
#     Environment = "training"
#     Student = each.value
#   }
# }

# #########################################################
# # Data Objects
# #########################################################

# # Get the students group
# data "aws_iam_group" "students" {
#   group_name = "students"
# }

# # Get latest Amazon Linux 2 AMI
# data "aws_ami" "amazon-linux-2" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm*"]
#   }
# }

# #########################################################
# # Resource Objects
# #########################################################

# resource "aws_iam_user_group_membership" "students" {

#   for_each = local.student_count
#   user = each.value
#   groups = [data.aws_iam_group.students.group_name]
# }