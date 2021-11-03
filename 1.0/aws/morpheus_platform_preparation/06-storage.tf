resource "aws_efs_file_system" "ui_shared_storage" {
    creation_token = "ui-shared"
}

resource "aws_efs_mount_target" "ui_shared_target" {
    for_each = local.az_map

    file_system_id = aws_efs_file_system.ui_shared_storage.id
    subnet_id = aws_subnet.public_subnets[each.key].id
    security_groups = [ aws_security_group.nfs.id ]
}