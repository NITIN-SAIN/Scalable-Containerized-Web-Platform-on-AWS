output "alb_sg_id" {
  description = "Security Group ID for Application Load Balancer"
  value       = aws_security_group.alb_sg.id
}

output "compute_sg_id" {
  description = "Security Group ID for compute resources"
  value       = aws_security_group.compute_sg.id
}

output "rds_sg_id" {
  description = "Security Group ID for RDS"
  value       = aws_security_group.rds_sg.id
}