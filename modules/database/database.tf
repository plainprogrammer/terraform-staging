variable "team" {
  type = string
}

variable "environment" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

resource "aws_db_subnet_group" "databases" {
  name        = "${var.team}-${var.environment}-database-subnet"
  subnet_ids  = var.subnet_ids
}

resource "aws_rds_cluster" "cluster" {
  cluster_identifier        = "${var.team}-${var.environment}-db"
  engine                    = "aurora-mysql"
  engine_version            = "5.7.mysql_aurora.2.07.1"
  engine_mode               = "provisioned"
  availability_zones        = ["us-west-2a", "us-west-2b"]
  storage_encrypted         = true
  database_name             = "mavenlink"
  master_username           = "mavenlink"
  master_password           = "password"
  backup_retention_period   = 30
  db_subnet_group_name      = aws_db_subnet_group.databases.name
  copy_tags_to_snapshot     = true
  final_snapshot_identifier = "${var.team}-${var.environment}-db-FINAL"

  tags = {
    Team = var.team
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count                 = 2
  identifier            = "${var.team}-${var.environment}-db${count.index}"
  cluster_identifier    = aws_rds_cluster.cluster.id
  instance_class        = "db.t3.large"
  copy_tags_to_snapshot = true

  tags = {
    Team = var.team
  }
}
