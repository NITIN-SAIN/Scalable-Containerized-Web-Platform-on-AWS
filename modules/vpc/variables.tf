variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
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