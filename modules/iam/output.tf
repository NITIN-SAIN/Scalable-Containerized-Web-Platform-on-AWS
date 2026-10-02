output "ec2_ssm_role_name" {
  description = "Name of the EC2 SSM IAM role"
  value       = aws_iam_role.ec2_ssm_role.name
}

output "ec2_ssm_role_arn" {
  description = "ARN of the EC2 SSM IAM role"
  value       = aws_iam_role.ec2_ssm_role.arn
}

output "ec2_instance_profile_name" {
  description = "Name of the EC2 IAM instance profile"
  value       = aws_iam_instance_profile.ec2_ssm_role.name
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution IAM role"
  value       = aws_iam_role.ecs_task_execution.arn
}