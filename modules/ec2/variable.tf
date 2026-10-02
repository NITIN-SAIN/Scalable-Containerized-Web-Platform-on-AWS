variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name for EC2"
  type        = string
}

variable "compute_sg_id" {
  description = "Security group ID for EC2 instances"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "private_subnet_1a" {
  description = "Private subnet ID in ap-south-1a"
  type        = string
}

variable "private_subnet_1b" {
  description = "Private subnet ID in ap-south-1b"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN for EC2 instances"
  type        = string
}