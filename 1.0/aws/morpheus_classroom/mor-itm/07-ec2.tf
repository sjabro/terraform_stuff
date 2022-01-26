resource "aws_key_pair" "trainer_key_pair" {
    key_name = "trainer_ssh_key"
    public_key = var.ssh_public_key
}

### SINGLE NODE

## TODO Export IPs of single node and three node nodes
resource "aws_eip" "single_node" {
    vpc = true
    instance = aws_instance.single_node.id
}

resource "aws_eip_association" "single_node_interface" {
    network_interface_id = aws_network_interface.single_node.id
    instance_id = aws_instance.single_node.id
    allocation_id = aws_eip.single_node.id
}

resource "aws_network_interface" "single_node" {
    subnet_id = aws_subnet.public_subnets[0].id
    security_groups = [ aws_security_group.app_nodes.id, aws_security_group.nfs.id ]
}

resource "aws_instance" "single_node" {
    ami = local.system_options.ami
    instance_type = "t2.xlarge"
    availability_zone = "${var.region}a"

        network_interface {
        network_interface_id = aws_network_interface.single_node.id
        device_index = 0
    }

    root_block_device {
        volume_size = 20     
    }

    key_name = aws_key_pair.trainer_key_pair.key_name

    tags = {
      "Name" = "morph-single-node"
    }

    user_data = <<-EOF
#!/bin/bash
# Update OS
${local.system_options.package_manager} update -y
${local.system_options.package_manager} install -y ${local.system_options.nfs_tool}
${local.system_options.package_manager} install -y ${local.system_options.mysql_client}
${local.system_options.package_manager} install -y jq 

mkdir -p /var/opt/morpheus/morpheus-ui
EOF
}


### 3-NODE
resource "aws_network_interface" "app_nodes" {
    for_each = local.az_map
    subnet_id = aws_subnet.public_subnets[each.key].id

    security_groups = [ aws_security_group.app_nodes.id, aws_security_group.nfs.id ]
}
resource "aws_instance" "app_node" {
    for_each = local.az_map

    ami = local.system_options.ami
    instance_type = "t2.xlarge"
    availability_zone = each.value

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