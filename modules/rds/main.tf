resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "scalable-web-rds-subnet-group"

  subnet_ids = [
    var.private_subnet_1a,
    var.private_subnet_1b
  ]

  tags = {
    Name        = "scalable-web-rds-subnet-group"
    Environment = "dev"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "scalable-web-postgres"

  engine         = "postgres"
  engine_version = "18.3"

  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username

  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  vpc_security_group_ids = [
    var.rds_sg_id
  ]

  publicly_accessible = false

  skip_final_snapshot = true

  lifecycle {
    ignore_changes = [
      password
    ]
  }

  tags = {
    Name        = "scalable-web-postgres"
    Environment = "dev"
  }
}