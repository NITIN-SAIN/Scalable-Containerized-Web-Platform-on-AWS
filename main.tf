
module "vpc" {
  source = "./modules/vpc"
}

module "security_groups" {
  source = "./modules/security_groups"

  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"
}

module "ecr" {
  source = "./modules/ecr"
}

module "alb" {
  source = "./modules/alb"

  vpc_id            = module.vpc.vpc_id
  alb_sg_id         = module.security_groups.alb_sg_id
  public_subnet_1a  = module.vpc.public_subnet_ids["ap-south-1a"]
  private_subnet_1b = module.vpc.private_subnet_ids["ap-south-1b"]
}

module "ec2" {
  source = "./modules/ec2"

  ami_id                = data.aws_ssm_parameter.al2023_ami.value
  instance_type         = var.instance_type
  instance_profile_name = module.iam.ec2_instance_profile_name
  compute_sg_id         = module.security_groups.compute_sg_id
  aws_region            = var.aws_region
  ecr_repository_url    = module.ecr.repository_url

  private_subnet_1a = module.vpc.private_subnet_ids["ap-south-1a"]
  private_subnet_1b = module.vpc.private_subnet_ids["ap-south-1b"]

  target_group_arn = module.alb.ec2_target_group_arn
}

module "rds" {
  source = "./modules/rds"

  private_subnet_1a = module.vpc.private_subnet_ids["ap-south-1a"]
  private_subnet_1b = module.vpc.private_subnet_ids["ap-south-1b"]

  rds_sg_id = module.security_groups.rds_sg_id

  db_name           = var.db_name
  db_username       = var.db_username
  db_instance_class = var.db_instance_class
}


module "ecs" {
  source = "./modules/ecs"

  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecr_repository_url          = module.ecr.repository_url
  aws_region                  = var.aws_region

  cluster_id            = module.ecs.cluster_id
  private_subnet_1a     = module.vpc.private_subnet_ids["ap-south-1a"]
  private_subnet_1b     = module.vpc.private_subnet_ids["ap-south-1b"]
  compute_sg_id         = module.security_groups.compute_sg_id
  ecs_target_group_arn  = module.alb.ecs_target_group_arn
  ecs_listener_rule_arn = module.alb.ecs_listener_rule_arn
}

data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}



resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/scalable-web-app"
  retention_in_days = 7

  tags = {
    Name        = "scalable-web-app-logs"
    Project     = "Scalable-Web-Platform"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}




resource "random_password" "db_passwd" {
  length  = 16
  special = true
}


resource "aws_secretsmanager_secret" "secret_manager_db" {
  name = "scalable-web-postgres-credentials"

  tags = {
    Name        = "scalable-web-postgres-credentials"
    Environment = "dev"
  }
}


resource "aws_secretsmanager_secret_version" "store_credential_db" {
  secret_id = aws_secretsmanager_secret.secret_manager_db.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_passwd.result
    db_name  = var.db_name
  })
}

resource "aws_sns_topic" "alarm" {
  name = "scalable-web-platform-alarm"
}

resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.alarm.arn
  protocol  = "email"
  endpoint  = "ns448875@gmail.com"
}