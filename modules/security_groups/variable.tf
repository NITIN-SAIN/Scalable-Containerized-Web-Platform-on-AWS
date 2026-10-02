variable "vpc_id" {
  description = "VPC ID for the security groups"
  type        = string
  default     = "module.vpc.vpc_id"
}