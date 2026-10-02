variable "private_subnet_1a" {
  description = "Private subnet ID in ap-south-1a"
  type        = string
}

variable "private_subnet_1b" {
  description = "Private subnet ID in ap-south-1b"
  type        = string
}

variable "rds_sg_id" {
  description = "Security group ID for PostgreSQL RDS"
  type        = string
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
}

variable "db_username" {
  description = "PostgreSQL master username"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}