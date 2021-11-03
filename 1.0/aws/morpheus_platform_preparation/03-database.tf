###################################################
#  MYSQL
####################################################
resource "aws_db_subnet_group" "main" {
  name = "morpheus-db-subnets"
  subnet_ids = [aws_subnet.database_subnets[0].id,aws_subnet.database_subnets[1].id,aws_subnet.database_subnets[2].id]

  tags = {
    "Name" = "Morpheus DB Subnets"
  }
}

resource "aws_rds_cluster_parameter_group" "main" {
  name = "morpheus-custom-parameters"
  family = "aurora-mysql5.7"
  description = "Custom parameters for the Morpheus database"
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_rds_cluster" "main" {

  port = 3306
  cluster_identifier = "morpheus-platform-aurora"
  engine = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.10.1"
  availability_zones = local.azs
  database_name = "morpheus"
  master_username = "morpheus"
  master_password = "M0rph3usDBP4ssw0rd!"
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name = aws_db_subnet_group.main.name
  skip_final_snapshot = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.main.name
}

resource "aws_rds_cluster_instance" "main" {
  for_each = local.az_map

  apply_immediately = true
  cluster_identifier = aws_rds_cluster.main.id
  identifier = "morph-db-instance-${each.value}"
  instance_class = "db.r5.large"
  engine = aws_rds_cluster.main.engine
  engine_version = aws_rds_cluster.main.engine_version
  db_subnet_group_name = aws_db_subnet_group.main.name
  availability_zone = each.value
}

resource "aws_rds_cluster_endpoint" "main" {

  cluster_identifier = aws_rds_cluster.main.id
  cluster_endpoint_identifier = "morpheus-rds-endpoint"
  custom_endpoint_type = "READER"

}