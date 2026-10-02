output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value = {
    for az, subnet in aws_subnet.public_sub : az => subnet.id
  }
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value = {
    for az, subnet in aws_subnet.private_sub : az => subnet.id
  }
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nate_Gateway.id
}