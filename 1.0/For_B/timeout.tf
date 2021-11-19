terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.35.0"
    }
  }
}

provider "aws" {

  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

  default_tags {
    
    tags = {
      Usage = "Morpheus Platform Infrastructure"
    }
  }
}

variable "region" {
    type = string
}

variable "access_key" {
    type = string
}

variable "secret_key" {
    type = string
}

variable "students" {
    type = list(string)
    description = "Comma separate list of student emails. (With quotes)"
}

variable "morph_version" {
    type = string
    default = "5.2.11-2"
}

locals {
  student_list = {for s in var.students: index(var.students, s) => s}
}

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
    "Name" = "${each.value}_vpc"
  }
}

resource "aws_internet_gateway" "main" {
  for_each = local.student_list
  vpc_id = aws_vpc.main[each.key].id

  tags = {
    "Name" = "${each.value}_igw"
  }

  depends_on = [
    aws_vpc.main
  ]
}

resource "aws_route_table" "main" {
  for_each = local.student_list
  vpc_id = aws_vpc.main[each.key].id

  depends_on = [
    aws_vpc.main
  ]

  tags = {
    "Name" = "${each.value}_rtb"
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

  depends_on = [
    aws_subnet.public_subnets,
    aws_route_table.main
  ]

}

resource "aws_subnet" "public_subnets" {
  for_each = local.student_list
  vpc_id = aws_vpc.main[each.key].id
  availability_zone = "${var.region}a"
  cidr_block = var.vpc_root_cidr 

  tags = {
    "Name" = "${each.value}_subnet"
  }

  depends_on = [
    aws_vpc.main
  ]
}

############################################################################
# SG Vars
############################################################################

# TODO get ssh ingress IP specific working
variable "ssh_ingress_cidrs" {
    type = list(string)
    description = "CIDRs allowed to access this system over SSH"
    default = ["0.0.0.0/0"]
}

resource "aws_security_group" "app_nodes" {
  for_each = local.student_list
  name = "Morpheus App Node Security Group"
  description = "Allows communication in for Morpheus app nodes"
  vpc_id = aws_vpc.main[each.key].id

  depends_on = [
    aws_vpc.main
  ]

  ingress = [ 
    {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow HTTPS in"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
    },
    {
    cidr_blocks = var.ssh_ingress_cidrs
    description = "Allow SSH in"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
    }
   ]
  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow ALL Out"
    from_port = 0
    to_port = 0
    protocol = "-1"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  } ]
  tags = {
    "Name" = "${each.value}-sg"
  }
}

######################################################################################
# EC2 Variables
######################################################################################
variable "os" {
    type = string
    # default = "ubuntu"
    default = "<%=customOptions.awsOsOption%>"
    description = "Select the OS for the deployment. Allowed values are ubuntu & amazon_linux"
    # validation {
    #   condition = anytrue([
    #       var.os == "ubuntu",
    #       var.os == "amazon_linux"
    #   ])
    #   error_message = "Must be a valid OS. Valid options are ubuntu or amazon_linux."
    # }
}

######################################################################################
# ECS Locals
######################################################################################
locals {
    system_options = {
    "ami" = var.os == "ubuntu" ? data.aws_ami.ubuntu_2004_latest.id : data.aws_ami.amazon_linux_2_latest.id
    "morph_install_command" = var.os == "ubuntu" ? "dpkg -i" : "rmp -ihv"
    "package_manager" =  var.os == "ubuntu" ? "apt-get" : "yum"
    "nfs_tool" = var.os == "ubuntu" ? "nfs-common" : "nfs-utils"
    "mysql_client" = var.os == "ubuntu" ? "mysql-client-core-8.0" : "mysql"  
  }
}

######################################################################################
# EC2 Data
######################################################################################
data "aws_ami" "amazon_linux_2_latest" {
    most_recent = true
    owners = ["amazon"]
    filter {
      name = "name"
      values = ["amzn2-ami-hvm*"]
    }
}

data "aws_ami" "ubuntu_2004_latest" {
    most_recent = true
    owners = ["099720109477"] # Canonical
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }   
}

########################################################################################
# EC2 Instances
########################################################################################
resource "aws_key_pair" "trainer_key_pair" {
    key_name = "jabro_ssh_pub"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdzzp2PB6cDTIpK1m1S6YaeXAROsLaROMiVPucRHKS6WgaRCfVpDpK0uZtTUyXcva+zqMXtjctBKAJw/wlU9tBJkCllUyuzWwdGc0aP0Ey1XcSjq02aqhgv0sMrgPkKpuA6jBF002yAAf0b55ZfaiDkMjTmRUqLprnhaMTC6jfWgE3KwexWUVbt+9aomvYMdvogqyRdD+075peaJHh0aemQoOjJ6tIOamLvU7AzDtbmxBMLhjyzzeSg+Xn72kegNj+kpd0FuWQVidJzlKZ/iX5D6DFnZOB8MnOhK2KQ/6syhfIJZA7VgBk0Fsyoqah5LPhWjJzo7OVQvUBLZNnhi/l"

    depends_on = [
      aws_vpc.main
    ]
}

resource "aws_network_interface" "app_nodes" {
    for_each = local.student_list
    subnet_id = aws_subnet.public_subnets[each.key].id

    security_groups = [ aws_security_group.app_nodes[each.key].id]

    depends_on = [
      aws_subnet.public_subnets,
      aws_internet_gateway.main
    ]
}

resource "aws_instance" "app_node" {
    for_each = local.student_list

    ami = local.system_options.ami
    instance_type = "m4.large"
    availability_zone = "${var.region}a"

    network_interface {
        network_interface_id = aws_network_interface.app_nodes[each.key].id
        device_index = 0
    }

    root_block_device {
        volume_size = 20     
    }

    key_name = aws_key_pair.trainer_key_pair.key_name

    tags = {
      "Name" = "${each.value}_morpheus-app"
    }

    depends_on = [
      aws_key_pair.trainer_key_pair,
      aws_internet_gateway.main
    ]

    user_data = <<-EOF
   #cloud-config
   runcmd:
   - wget https://downloads.morpheusdata.com/files/morpheus-appliance_${var.morph_version}_amd64.deb
   - ${local.system_options.morph_install_command} morpheus-appliance_${var.morph_version}_amd64.deb
   - sleep 30
   - sed -i '/^appliance_url/d' /etc/morpheus/morpheus.rb
   - address="https://${aws_eip.app_nodes[each.key].public_ip}"
   - echo "appliance_url '$address'" >> /etc/morpheus/morpheus.rb
   - morpheus-ctl reconfigure
  EOF
}
resource "aws_eip" "app_nodes" {
    for_each = local.student_list

    vpc = true

    depends_on = [
      aws_vpc.main,
      aws_internet_gateway.main
    ]

    # instance = aws_instance.app_node[each.key].id
}

resource "aws_eip_association" "app_node_interfaces" {
    for_each = local.student_list

    network_interface_id = aws_network_interface.app_nodes[each.key].id
    instance_id = aws_instance.app_node[each.key].id
    allocation_id = aws_eip.app_nodes[each.key].id

    depends_on = [
      aws_network_interface.app_nodes,
      aws_instance.app_node
    ]
}

###################################################################################################################
#  IAM 
###################################################################################################################
data "aws_iam_group" "students" {
  group_name = "students"
}

resource "aws_iam_user" "user" {
  for_each = local.student_list
  name = "${each.value}"
}

resource "aws_iam_access_key" "user_key" {
  for_each = local.student_list
  user = aws_iam_user.user[each.key].name
}

resource "aws_iam_user_group_membership" "students" {

  depends_on = [
    aws_iam_user.user,
    data.aws_iam_group.students
  ]
  
  for_each = local.student_list
  user = each.value
  groups = [data.aws_iam_group.students.group_name]
}