locals {
  student_count = {for u in var.students: index(var.students, u) => u}
  system_options = {
    "ami" = var.os == "ubuntu" ? data.aws_ami.ubuntu_2004_latest.id : data.aws_ami.amazon_linux_2_latest.id
    "package_manager" =  var.os == "ubuntu" ? "apt-get" : "yum"
    "nfs_tool" = var.os == "ubuntu" ? "nfs-common" : "nfs-utils"
    "mysql_client" = var.os == "ubuntu" ? "mysql-client-core-8.0" : "mysql"  
  }
}