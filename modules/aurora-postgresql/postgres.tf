locals {
  resource_tags = {
    "Name"  = var.pgdb_name
    }
}

resource "aws_db_subnet_group" "default" {
  name       = var.pgdb_name
  subnet_ids = var.subnet_ids
  tags       =  local.resource_tags
}

resource "aws_rds_cluster_instance" "default" {
  count                 = var.instance_count
  identifier            = "${var.pgdb_name}-${count.index}"
  cluster_identifier    = aws_rds_cluster.default.id
  instance_class        = var.rds_instance_class
  engine                = var.engine
  tags                  =  local.resource_tags
  copy_tags_to_snapshot = "true"
}

resource "aws_kms_key" "default" {
  description             = "KMS key for encryption"
  deletion_window_in_days = 10
}

resource "aws_rds_cluster" "default" {
  skip_final_snapshot             = var.skip_final
  final_snapshot_identifier       = "${var.pgdb_name}-final-${formatdate("YYYYMMDDHHMMss",timestamp())}"
  db_subnet_group_name            = aws_db_subnet_group.default.name
  cluster_identifier              = var.pgdb_name
  engine                          = var.engine
  master_username                 = var.pgdb_username
  master_password                 = var.pgdb_password
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.default.name
  vpc_security_group_ids          = [aws_security_group.default.id]
  storage_encrypted               = true
  tags                            = local.resource_tags
  copy_tags_to_snapshot           = true
  backup_retention_period         = var.backup_retention
}

resource "aws_rds_cluster_parameter_group" "default" {
  family                          = var.family
  name                            = var.pgdb_name

  parameter {
    name                          = "character_set_server"
    value                         = "utf8"
  }

  parameter {
    name                          = "character_set_client"
    value                         = "utf8"
  }
  tags                            =  local.resource_tags
}

resource "aws_security_group" "default" {
  name                            = var.pgdb_name
  vpc_id                          = var.vpc_id

  ingress {
    from_port                     = 5432
    to_port                       = 5432
    protocol                      = "TCP"
    cidr_blocks                   = var.ingress_blocks
  }
  tags                            =  local.resource_tags
}

resource "aws_iam_role" "monitoring_role" {
  count              = var.create_monitoring_iam_role == true ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.monitoring_policy.json
  description        = "IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs."
  name               = var.pgdb_name
  tags               = local.resource_tags
}

resource "aws_iam_policy_attachment" "monitoring-policy-attachment" {
  name       = "monitoring-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  roles      = [aws_iam_role.monitoring_role[0].name]
}

data "aws_iam_policy_document" "monitoring_policy" {
  statement {
    sid           = "AssumeRolePolicy"
    effect        = "Allow"
    actions       = ["sts:AssumeRole"]
    principals {
      identifiers = ["rds.amazonaws.com", "monitoring.rds.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "external" "snapshot_identifier" {
  program = ["${path.module}/scripts/get-latest-cluster-snapshot-id.sh","${var.pgdb_name}"]
}

