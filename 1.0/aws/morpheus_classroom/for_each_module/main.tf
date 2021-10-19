################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  for_each = local.student_count
  name = each.value
  cidr = cidrsubnet(var.vpc_root_cidr, 4, each.key)

  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = []
  public_subnets  = [cidrsubnet(var.vpc_root_cidr, 4, each.key)]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = false

  public_subnet_tags = {
    "Name" = "${each.value}_subnet"
  }

  tags = {
    Student = each.value
  }

  vpc_tags = {
    "Name" = each.value
  }
}

################################################################################
# Security Group Module 
################################################################################

module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"
  
  depends_on = [
    module.vpc
  ]

  for_each = local.student_count
  name = each.value
  description = "Security group built for Morpheus training classes"
  vpc_id = module.vpc[each.key].vpc_id

    egress_with_cidr_blocks = [
      {
      from_port = 0
      to_port   = 0
      protocol = "-1"
      cidr_blocks = "0.0.0.0/0"
      }
    ]

    ingress_with_cidr_blocks = [
    {
      from_port   = 1024
      to_port     = 25535
      protocol    = "tcp"
      description = "High Ports Allow In"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTPS in"
    },
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTP in"
    },
    {
      rule        = "winrm-https-tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow WINRMs in"
    },
    {
      rule        = "winrm-http-tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow WINRM in"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow SSH in"
    }
  ]
}

################################################################################
# IAM Module 
################################################################################

module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 4.3"

  for_each = local.student_count
  name          = each.value
  force_destroy = true

  create_iam_user_login_profile = false
  create_iam_access_key         = true
}

################################################################################
# EC2 Module 
################################################################################

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  depends_on = [
    module.vpc
  ]

  for_each = local.student_count

  name = "instance-${each.value}"

  ami                    = local.amis[var.region]
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.security-group[each.key].security_group_id]
  subnet_id              = module.vpc[each.key].public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "training"
    Student = each.value
  }
}

module "morpheus_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  depends_on = [
    module.vpc
  ]

  for_each = local.student_count

  name = "morpheus-${each.value}"

  ami                    = local.amis[var.region]
  instance_type          = "t2.large"
  vpc_security_group_ids = [module.security-group[each.key].security_group_id]
  subnet_id              = module.vpc[each.key].public_subnets[0]
  associate_public_ip_address = true
  
  user_data = <<-EOF
   #cloud-config
   runcmd:
   - <%=instance.cloudConfig.agentInstall%>
   - <%=instance.cloudConfig.finalizeServer%>
   EOF
  tags = {
    Terraform   = "true"
    Environment = "training"
    Student = each.value
  }
}

#########################################################
# Data Objects
#########################################################

# Get the students group
data "aws_iam_group" "students" {
  group_name = "students"
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

#########################################################
# Resource Objects
#########################################################

resource "aws_iam_user_group_membership" "students" {

  depends_on = [
    module.iam_user,
    data.aws_iam_group.students
  ]
  
  for_each = local.student_count
  user = each.value
  groups = [data.aws_iam_group.students.group_name]
}