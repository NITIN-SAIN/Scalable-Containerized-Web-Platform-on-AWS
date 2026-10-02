resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "Scalable-web-vpc"
    Environment = "dev"
  }
}

resource "aws_subnet" "public_sub" {
  for_each = var.Public_Subnet_cidrs

  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = each.value

  map_public_ip_on_launch = true

  tags = {
    Name        = "scalable-web-public-$(each.key)"
    Environment = "dev"
  }
}

resource "aws_subnet" "private_sub" {
  for_each = var.Private_Subnet_cidrs

  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = each.value

  map_public_ip_on_launch = false

  tags = {
    Name        = "scalable-web-private-${each.key}"
    Environment = "dev"
  }
}

resource "aws_internet_gateway" "Main_IGW" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "scalable-web-igw"
    Environment = "dev"
  }
}

resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "Scalable-web-public-rt"
    Environment = "deb"
  }
}

resource "aws_route" "public_internet" {

  route_table_id         = aws_route_table.public_RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Main_IGW.id
}

resource "aws_route_table_association" "attch_pub_rt_to_pub_subnet" {
  for_each = aws_subnet.public_sub

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_RT.id

}

resource "aws_eip" "nat_elastic_ip" {
  domain = "vpc"

  tags = {
    Name        = "scalable-web-nat-eip"
    Environment = "dev"
  }
}

resource "aws_nat_gateway" "nate_Gateway" {
  allocation_id = aws_eip.nat_elastic_ip.id

  subnet_id = aws_subnet.public_sub["ap-south-1a"].id

  depends_on = [
    aws_internet_gateway.Main_IGW
  ]
}


resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "scalable-web-private-rt"
    Environment = "dev"
  }
}

resource "aws_route" "private_internat" {

  route_table_id         = aws_route_table.private_RT.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nate_Gateway.id

}

resource "aws_route_table_association" "attach_private_sub_to_pr_route" {
  for_each = aws_subnet.private_sub

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_RT.id
}