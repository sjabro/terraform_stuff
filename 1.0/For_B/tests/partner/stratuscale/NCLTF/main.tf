terraform {
  required_version = ">= 0.12.26"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.49"
    }
  }
}

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

variable "access_key" {
}
variable "secret_key" {
}

variable "account" {
  type = number
  description = "AWS account to deploy RDS Mysql cluster and resources."
  #default = "<%=customOptions.awsAccountID%>"
  #default = "653234354353"
}

variable "vpc_id" {
  type = string
  description = "VPC in which to deploy RDS and resources."
  default = "vpc-0db0ed9c49b31257a"
}

variable "region" {
  type = string
  description = "AWS region to deploy RDS Mysql cluster and resources."
  # default = "us-east-1"
}

variable "project_name" {
  type = string
  description = "Name to prefix RDS Mysql cluster and resources."
  default = "NCL"
}

variable "owner" {
  type = string
  description = "Project Owner."
  default = "Jabro"
}

variable "environment" {
  type = string
  description = "Project Environment."
  default = "Prod"
}

variable "cost_center" {
  type = string
  description = "Project Cost Center"
  default = "100029"
}

# rds vars
variable "rds_subnet_1" {
  type = string
  description = "Subnets in which to deploy the RDS Mysql clusters."
  default = "manual-subnet-private-1a"
}

variable "rds_subnet_2" {
  type = string
  description = "Subnets in which to deploy the RDS Mysql clusters."
  default = "manual-subnet-private-1b"
}

variable "rds_subnet_3" {
  type = string
  description = "Subnets in which to deploy the RDS Mysql clusters."
  default = "manual-subnet-private-1c"
}

variable "rds_engine_version" {
  type = string
  description = "RDS Mysql engine version."
  default = "5.7"
}

variable "rds_major_engine_version" {
  type = string
  description = "RDS Mysql major engine version."
  # default = "<%=customOptions.mySQLMajorVersion%>"
}

variable "rds_engine_family" {
  type = string
  description = "RDS Mysql engine family."
  default = "mysql5.7"
}

variable "rds_instance_type" {
  type = string
  description = "RDS Mysql cluster instance type."
  default = "db.t3.small"
}

variable "rds_disk_size" {
  type = number
  description = "Disk size for RDS Mysql cluster instances in GB."
  default = 10
}

variable "create_db_replica" {
  type = bool
  description = "Create a mysql DB replica or not."
  default = "false"
}

variable "db_instance_user" {
  type = string
  description = "Mysql DB instance username."
  default = "admin"
}

variable "db_instance_user_password" {
  type = string
  description = "Mysql DB instance username."
  default = "password1"
}

variable "db_multi_az_enable" {
  type = bool
  description = "Enable Multi-AZ deployment for RDS Cluster."
  default = false
}

variable "db_deletion_protection" {
  type = bool
  description = "Enable deletion protection mySQL db instance."
  default = false
}

variable "db_delete_automated_backups" {
  type = bool
  description = "Delete automated backups for mySQL db instance."
  default = true
}

variable "db_publicly_accessible" {
  type = bool
  description = "Enable or disable public accessibility for mySQL db instance."
  default = false
}

variable "db_skip_final_snapshot" {
  type = bool
  description = "create or skip fina snapshot creation for mySQL db instance."
  default = true
}

variable "db_performance_insights_enabled" {
  description = "Enable performance monitoring insights for mySQL db instance."
  type        = bool
  default = false
}

# variable "db_kms_key_id" {
#   type = string
#   description = "KMS key id to encrypt data in mySQL db instance."
#   default = "bdaaa764-b2a6-4f8f-b2ca-7e5caabe1fbd"
# }

variable "db_backup_retention_period" {
  type = number
  description = "How long in days to retain backups."
  default = 10
}


####################################
# Variables common to both instnaces
####################################
locals {
  db_engine               = "mysql"
  db_major_engine_version = var.rds_major_engine_version
  db_engine_version       = var.rds_engine_version
  db_engine_family        = var.rds_engine_family
  db_cluster_name         = "${lower(var.project_name)}mysqldb"
  db_instance_class       = var.rds_instance_type
  db_allocated_storage    = var.rds_disk_size
  db_port                 = 3306
  tags = {
    Owner         = var.owner
    Environment   = var.environment
    "Cost Center" = var.cost_center
  }
}


# Data sources to get VPC and subnets
data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name = "tag:Name"
    values = [var.rds_subnet_1, var.rds_subnet_2, var.rds_subnet_3]
  }
}

resource "random_id" "rds_random_id" {
  byte_length = 4
}

resource "aws_security_group" "rds_security_group" {
  name   = "${lower(local.db_cluster_name)}-sg-${random_id.rds_random_id.hex}"
  vpc_id = data.aws_vpc.selected.id

  ingress = [
    {
      description = "RDS Access Ingress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [
        "10.0.0.0/8",
        "167.118.0.0/16",
        "192.168.200.0/24",
        "192.168.170.0/24"
      ]
      security_groups  = []
      self             = false
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
    }
  ]

  egress = [
    {
      description      = "RDS Access Egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      security_groups  = []
      self             = false
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
    }
  ]

  tags = local.tags
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  name_prefix        = "${lower(local.db_cluster_name)}-monitoring"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

# Master DB
module "master" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${lower(local.db_cluster_name)}-${random_id.rds_random_id.hex}"

  engine               = local.db_engine
  major_engine_version = local.db_major_engine_version
  engine_version       = local.db_engine_version
  family               = local.db_engine_family
  instance_class       = local.db_instance_class
  allocated_storage    = local.db_allocated_storage

  name     = local.db_cluster_name
  username = var.db_instance_user
  password = var.db_instance_user_password
  port     = local.db_port

  multi_az                  = var.db_multi_az_enable
  vpc_security_group_ids    = [aws_security_group.rds_security_group.id]
  final_snapshot_identifier = "${lower(local.db_cluster_name)}-snapshot-${random_id.rds_random_id.hex}"
  skip_final_snapshot       = var.db_skip_final_snapshot
  copy_tags_to_snapshot     = true
  deletion_protection       = var.db_deletion_protection
  delete_automated_backups  = var.db_delete_automated_backups
  storage_encrypted         = true
  # kms_key_id                = "arn:aws:kms:${var.region}:${var.account}:key/${var.db_kms_key_id}"

  # DB maintenance
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  # DB monitoring
  enabled_cloudwatch_logs_exports       = ["audit", "general"]
  monitoring_interval                   = 30
  monitoring_role_name                  = "${lower(local.db_cluster_name)}-monitoring-${random_id.rds_random_id.hex}"
  performance_insights_enabled          = var.db_performance_insights_enabled
  performance_insights_retention_period = 7
  create_monitoring_role                = true

  # Backups are required in order to create a replica
  backup_retention_period = var.db_backup_retention_period

  # DB subnet group
  subnet_ids = data.aws_subnet_ids.subnets.ids

  create_db_option_group    = true
  create_db_parameter_group = true

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
      ]
    },
  ]
  tags = local.tags

}

############
# Replica DB
############
module "replica" {

  source = "terraform-aws-modules/rds/aws"

  create_db_instance = var.create_db_replica ? true : false
  identifier         = "${lower(local.db_cluster_name)}-replica-${random_id.rds_random_id.hex}"

  # Source database. For cross-region use this_db_instance_arn
  replicate_source_db = module.master.db_instance_id
  publicly_accessible = var.db_publicly_accessible

  engine            = local.db_engine
  engine_version    = local.db_engine_version
  instance_class    = local.db_instance_class
  allocated_storage = local.db_allocated_storage

  multi_az                  = var.db_multi_az_enable
  deletion_protection       = var.db_deletion_protection
  delete_automated_backups  = var.db_delete_automated_backups
  final_snapshot_identifier = "${lower(local.db_cluster_name)}-replica-snapshot-${random_id.rds_random_id.hex}"
  skip_final_snapshot       = var.db_skip_final_snapshot
  copy_tags_to_snapshot     = true
  storage_encrypted         = true
  # kms_key_id                = "arn:aws:kms:${var.region}:${var.account}:key/${var.db_kms_key_id}"

  # Username and password should not be set for replicas
  username = ""
  password = ""
  port     = local.db_port

  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  maintenance_window = "Tue:00:00-Tue:03:00"
  backup_window      = "03:00-06:00"

  # DB monitoring
  enabled_cloudwatch_logs_exports       = ["audit", "general"]
  monitoring_interval                   = 30
  monitoring_role_name                  = "${lower(local.db_cluster_name)}-replica-monitoring-${random_id.rds_random_id.hex}"
  performance_insights_enabled          = var.db_performance_insights_enabled
  performance_insights_retention_period = 7
  create_monitoring_role                = true

  # disable backups to create DB faster
  backup_retention_period = 0

  # Not allowed to specify a subnet group for replicas in the same region
  create_db_subnet_group = false

  create_db_option_group    = false
  create_db_parameter_group = false

  tags = local.tags
}

# Master
output "master_db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.master.db_instance_address
}

output "master_db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.master.db_instance_arn
}

output "master_db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.master.db_instance_availability_zone
}

output "master_db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.master.db_instance_endpoint
}

output "master_db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.master.db_instance_hosted_zone_id
}

output "master_db_instance_id" {
  description = "The RDS instance ID"
  value       = module.master.db_instance_id
}

output "master_db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.master.db_instance_resource_id
}

output "master_db_instance_status" {
  description = "The RDS instance status"
  value       = module.master.db_instance_status
}

output "master_db_instance_name" {
  description = "The database name"
  value       = module.master.db_instance_name
}

output "master_db_instance_username" {
  description = "The master username for the database"
  value       = module.master.db_instance_username
  sensitive   = true
}

output "master_db_instance_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = module.master.db_instance_password
  sensitive   = true
}

output "master_db_instance_port" {
  description = "The database port"
  value       = module.master.db_instance_port
}

output "master_db_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.master.db_subnet_group_id
}

output "master_db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.master.db_subnet_group_arn
}

# Replica
// output "replica_db_instance_address" {
//   description = "The address of the RDS instance"
//   value       = module.replica.db_instance_address
// }

// output "replica_db_instance_arn" {
//   description = "The ARN of the RDS instance"
//   value       = module.replica.db_instance_arn
// }

// output "replica_db_instance_availability_zone" {
//   description = "The availability zone of the RDS instance"
//   value       = module.replica.db_instance_availability_zone
// }

// output "replica_db_instance_endpoint" {
//   description = "The connection endpoint"
//   value       = module.replica.db_instance_endpoint
// }

// output "replica_db_instance_hosted_zone_id" {
//   description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
//   value       = module.replica.db_instance_hosted_zone_id
// }

// output "replica_db_instance_id" {
//   description = "The RDS instance ID"
//   value       = module.replica.db_instance_id
// }

// output "replica_db_instance_resource_id" {
//   description = "The RDS Resource ID of this instance"
//   value       = module.replica.db_instance_resource_id
// }

// output "replica_db_instance_status" {
//   description = "The RDS instance status"
//   value       = module.replica.db_instance_status
// }

// output "replica_db_instance_name" {
//   description = "The database name"
//   value       = module.replica.db_instance_name
// }

// output "replica_db_instance_username" {
//   description = "The replica username for the database"
//   value       = module.replica.db_instance_username
//   sensitive   = true
// }

// output "replica_db_instance_port" {
//   description = "The database port"
//   value       = module.replica.db_instance_port
// }
