variable "aws_region" {
  description = "aws region where resource will create"
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "availability_zones for the project"
  default = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}

variable "Public_Subnet_cidrs" {
  description = "CIDR blocks for public Subnet"
  default = {
    "ap-south-1a" = "10.0.1.0/24"
    "ap-south-1b" = "10.0.2.0/24"
  }
}

variable "Private_Subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  default = {
    "ap-south-1a" = "10.0.11.0/24"
    "ap-south-1b" = "10.0.12.0/24"
  }
}

variable "instance_type" {
  description = " EC2 instance type for the application "
  default     = "t3.micro"
}


variable "db_name" {
  description = "PostgreSQL database name"
  default     = "scalableweb"
}

variable "db_username" {
  description = "PostgreSQL master name"
  default     = "admin"
}

variable "db_instance_class" {
  description = "RDS instance class"
  default     = "db.t3.micro"
}

