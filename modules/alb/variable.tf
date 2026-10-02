variable "vpc_id" {
  description = "VPC ID for the load balancer target groups"
  type        = string
}

variable "alb_sg_id" {
  description = "Security group ID for the Application Load Balancer"
  type        = string
}

variable "public_subnet_1a" {
  description = "Public subnet ID in ap-south-1a"
  type        = string
}

variable "private_subnet_1b" {
  description = "Private subnet ID in ap-south-1b"
  type        = string
}