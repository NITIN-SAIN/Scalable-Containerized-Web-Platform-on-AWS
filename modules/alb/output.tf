output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = aws_lb.alb.id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "ec2_target_group_arn" {
  description = "ARN of the EC2 target group"
  value       = aws_lb_target_group.alb_tg.arn
}

output "ecs_target_group_arn" {
  description = "ARN of the ECS target group"
  value       = aws_lb_target_group.ecs_tg.arn
}

output "listener_arn" {
  description = "ARN of the ALB HTTP listener"
  value       = aws_lb_listener.target_instance_ec2.arn
}

output "ecs_listener_rule_arn" {
  description = "ARN of the ECS listener rule"
  value       = aws_lb_listener_rule.ecs_listener_rule.arn
}