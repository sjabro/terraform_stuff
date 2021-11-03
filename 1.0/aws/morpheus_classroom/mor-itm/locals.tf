locals {
  azs = ["${var.region}a","${var.region}b","${var.region}c"]
  az_map = {for a in local.azs: index(local.azs, a) => a}
  system_options = {
    "ami" = var.os == "ubuntu" ? data.aws_ami.ubuntu_2004_latest.id : data.aws_ami.amazon_linux_2_latest.id
    "package_manager" =  var.os == "ubuntu" ? "apt-get" : "yum"
    "nfs_tool" = var.os == "ubuntu" ? "nfs-common" : "nfs-utils"
    "mysql_client" = var.os == "ubuntu" ? "mysql-client-core-8.0" : "mysql"  
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

data "aws_ami" "amazon_linux_2_latest" {
    most_recent = true
    owners = ["amazon"]
    filter {
      name = "name"
      values = ["amzn2-ami-hvm*"]
    }
}