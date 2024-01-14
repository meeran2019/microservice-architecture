resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-postgresql"
  master_username         = "admin"
  master_password         = random_password.password.result
  backup_retention_period = 7
  preferred_backup_window = "02:00-03:00"
  skip_final_snapshot     = true
  vpc_security_group_ids  = ["sg-0f41764056e6201d0"] 
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count               = 1
  identifier          = "aurora-instance-${count.index}"
  cluster_identifier  = aws_rds_cluster.aurora_cluster.id
  instance_class      = "db.t3.small"
  engine              = "aurora-postgresql"
  publicly_accessible = false
}
