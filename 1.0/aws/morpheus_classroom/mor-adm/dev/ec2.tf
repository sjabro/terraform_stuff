# ######################################################################################
# # EC2 Variables
# ######################################################################################
# variable "os" {
#     type = string
#     # default = "ubuntu"
#     default = "<%=customOptions.awsOsOption%>"
#     description = "Select the OS for the deployment. Allowed values are ubuntu & amazon_linux"
#     # validation {
#     #   condition = anytrue([
#     #       var.os == "ubuntu",
#     #       var.os == "amazon_linux"
#     #   ])
#     #   error_message = "Must be a valid OS. Valid options are ubuntu or amazon_linux."
#     # }
# }

# ######################################################################################
# # ECS Locals
# ######################################################################################
# locals {
#     system_options = {
#     "ami" = var.os == "ubuntu" ? data.aws_ami.ubuntu_2004_latest.id : data.aws_ami.amazon_linux_2_latest.id
#     "morph_install_command" = var.os == "ubuntu" ? "dpkg -i" : "rmp -ihv"
#     "package_manager" =  var.os == "ubuntu" ? "apt-get" : "yum"
#     "nfs_tool" = var.os == "ubuntu" ? "nfs-common" : "nfs-utils"
#     "mysql_client" = var.os == "ubuntu" ? "mysql-client-core-8.0" : "mysql"  
#   }
# }

# ######################################################################################
# # EC2 Data
# ######################################################################################
# data "aws_ami" "amazon_linux_2_latest" {
#     most_recent = true
#     owners = ["amazon"]
#     filter {
#       name = "name"
#       values = ["amzn2-ami-hvm*"]
#     }
# }

# data "aws_ami" "ubuntu_2004_latest" {
#     most_recent = true
#     owners = ["099720109477"] # Canonical
#     filter {
#         name = "name"
#         values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#     }
#     filter {
#         name = "virtualization-type"
#         values = ["hvm"]
#     }   
# }

# ########################################################################################
# # EC2 Instances
# ########################################################################################
# resource "aws_key_pair" "trainer_key_pair" {
#     key_name = "trainer_ssh_key"
#     public_key = var.ssh_public_key

#     depends_on = [
#       aws_vpc.main
#     ]
# }

# resource "aws_network_interface" "app_nodes" {
#     for_each = local.student_list
#     subnet_id = aws_subnet.public_subnets[each.key].id

#     security_groups = [ aws_security_group.app_nodes[each.key].id]

#     depends_on = [
#       aws_subnet.public_subnets,
#       aws_internet_gateway.main
#     ]
# }

# resource "aws_instance" "app_node" {
#     for_each = local.student_list

#     ami = local.system_options.ami
#     instance_type = "m4.large"
#     availability_zone = "${var.region}a"

#     network_interface {
#         network_interface_id = aws_network_interface.app_nodes[each.key].id
#         device_index = 0
#     }

#     root_block_device {
#         volume_size = 20     
#     }

#     key_name = aws_key_pair.trainer_key_pair.key_name

#     tags = {
#       "Name" = "${each.value}_morpheus-app"
#     }

#     depends_on = [
#       aws_key_pair.trainer_key_pair,
#       aws_internet_gateway.main
#     ]

#     user_data = <<-EOF
#    #cloud-config
#    runcmd:
#    - wget https://downloads.morpheusdata.com/files/morpheus-appliance_${var.morph_version}_amd64.deb
#    - ${local.system_options.morph_install_command} morpheus-appliance_${var.morph_version}_amd64.deb
#    - sleep 30
#    - sed -i '/^appliance_url/d' /etc/morpheus/morpheus.rb
#    - address="https://${aws_eip.app_nodes[each.key].public_ip}"
#    - echo "appliance_url '$address'" >> /etc/morpheus/morpheus.rb
#    - morpheus-ctl reconfigure
#   EOF
# }
# resource "aws_eip" "app_nodes" {
#     for_each = local.student_list

#     vpc = true

#     depends_on = [
#       aws_vpc.main,
#       aws_internet_gateway.main
#     ]

#     tags = {
#       "Name" = "${each.value}"
#     }
#     # instance = aws_instance.app_node[each.key].id
# }

# resource "aws_eip_association" "app_node_interfaces" {
#     for_each = local.student_list

#     network_interface_id = aws_network_interface.app_nodes[each.key].id
#     instance_id = aws_instance.app_node[each.key].id
#     allocation_id = aws_eip.app_nodes[each.key].id

#     depends_on = [
#       aws_network_interface.app_nodes,
#       aws_instance.app_node
#     ]
# }