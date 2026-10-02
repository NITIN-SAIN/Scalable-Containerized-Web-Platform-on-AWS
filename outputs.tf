output "ecr_repository_url" {
  description = "ECR repository URL for the application"
  value       = module.ecr.repository_url
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

