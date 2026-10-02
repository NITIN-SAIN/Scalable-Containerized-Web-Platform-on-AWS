variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "private_subnet_1a" {
  type = string
}

variable "private_subnet_1b" {
  type = string
}

variable "compute_sg_id" {
  type = string
}

variable "ecs_target_group_arn" {
  type = string
}

variable "ecs_listener_rule_arn" {
  type = string
}