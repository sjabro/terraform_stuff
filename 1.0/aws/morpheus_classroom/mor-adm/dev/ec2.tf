######################################################################################
# EC2 Variables
######################################################################################
variable "os" {
    type = string
    default = "ubuntu"
    validation {
      condition = anytrue([
          var.os == "ubuntu",
          var.os == "amazon_linux"
      ])
      error_message = "Must be a valid OS. Valid options are ubuntu or amazon_linux."
    }
}

######################################################################################
# ECS Locals
######################################################################################
locals {
    system_options = {
    "ami" = var.os == "ubuntu" ? data.aws_ami.ubuntu_2004_latest.id : data.aws_ami.amazon_linux_2_latest.id
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
}

resource "aws_network_interface" "app_nodes" {
    for_each = local.student_list
    subnet_id = aws_subnet.public_subnets[each.key].id

    security_groups = [ aws_security_group.app_nodes[each.key].id]
}

resource "aws_instance" "app_node" {
    for_each = local.student_list

    ami = local.system_options.ami
    instance_type = "t2.xlarge"
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
      "Name" = "${each.value}-morpheus-app"
    }

    user_data = <<-EOF
   #cloud-config
   runcmd:
   - wget https://downloads.morpheusdata.com/files/morpheus-appliance_5.3.3-2_amd64.deb
   - dpkg -i morpheus-appliance_5.3.3-2_amd64.deb
   - morpheus-ctl reconfigure
  EOF
}
resource "aws_eip" "app_nodes" {
    for_each = local.student_list

    vpc = true
    instance = aws_instance.app_node[each.key].id
}

resource "aws_eip_association" "app_node_interfaces" {
    for_each = local.student_list

    network_interface_id = aws_network_interface.app_nodes[each.key].id
    instance_id = aws_instance.app_node[each.key].id
    allocation_id = aws_eip.app_nodes[each.key].id
}