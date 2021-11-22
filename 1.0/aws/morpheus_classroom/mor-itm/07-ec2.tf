# TODO Variablize ssh public key
resource "aws_key_pair" "trainer_key_pair" {
    key_name = "jabro_ssh_pub"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdzzp2PB6cDTIpK1m1S6YaeXAROsLaROMiVPucRHKS6WgaRCfVpDpK0uZtTUyXcva+zqMXtjctBKAJw/wlU9tBJkCllUyuzWwdGc0aP0Ey1XcSjq02aqhgv0sMrgPkKpuA6jBF002yAAf0b55ZfaiDkMjTmRUqLprnhaMTC6jfWgE3KwexWUVbt+9aomvYMdvogqyRdD+075peaJHh0aemQoOjJ6tIOamLvU7AzDtbmxBMLhjyzzeSg+Xn72kegNj+kpd0FuWQVidJzlKZ/iX5D6DFnZOB8MnOhK2KQ/6syhfIJZA7VgBk0Fsyoqah5LPhWjJzo7OVQvUBLZNnhi/l"
}

resource "aws_network_interface" "app_nodes" {
    for_each = local.az_map
    subnet_id = aws_subnet.public_subnets[each.key].id

    security_groups = [ aws_security_group.app_nodes.id, aws_security_group.nfs.id ]
}

## TODO Add single node VM
## TODO Export IPs of single node and three node nodes
resource "aws_instance" "app_node" {
    for_each = local.az_map

    ami = local.system_options.ami
    instance_type = "t2.xlarge"
    availability_zone = each.value

    # subnet_id = aws_subnet.public_subnets[each.key].id
    # security_groups = [aws_security_group.app_nodes.id]

    network_interface {
        network_interface_id = aws_network_interface.app_nodes[each.key].id
        device_index = 0
    }

    root_block_device {
        volume_size = 20     
    }

    key_name = aws_key_pair.trainer_key_pair.key_name

    tags = {
      "Name" = "morph-app-0${each.key + 1}"
    }

    user_data = <<-EOF
#!/bin/bash
# Update OS
${local.system_options.package_manager} update -y
${local.system_options.package_manager} install -y ${local.system_options.nfs_tool}
${local.system_options.package_manager} install -y ${local.system_options.mysql_client}
${local.system_options.package_manager} install -y jq 

mkdir -p /var/opt/morpheus/morpheus-ui
echo "${aws_efs_mount_target.ui_shared_target[each.key].ip_address}:/ /var/opt/morpheus/morpheus-ui        nfs   defaults        0 0" | cat >> /etc/fstab
mount -a
EOF
}

resource "aws_eip" "app_nodes" {
    for_each = local.az_map

    vpc = true
    instance = aws_instance.app_node[each.key].id
}

resource "aws_eip_association" "app_node_interfaces" {
    for_each = local.az_map

    network_interface_id = aws_network_interface.app_nodes[each.key].id
    instance_id = aws_instance.app_node[each.key].id
    allocation_id = aws_eip.app_nodes[each.key].id

}