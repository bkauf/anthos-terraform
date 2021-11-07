terraform {
  required_version = ">= 0.12.23"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70.0"
    }
  }
}
locals {
  vpc_name = "${var.anthos_prefix}-vpc"
  az_count = length(var.subnet_availability_zones)
}

#Create a VPC

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
 tags = {
    Name = "${local.vpc_name}-anthos-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = local.vpc_name
  }
}

#Create 4 private subnets and 1 public subnet. 
#Three private subnets are used by the Anthos on AWS control planes (running in three zones)
# and one or more private subnets is used by node pools.
# The public subnets is used by the load balancers for assocaited services.

#4 Private Subnets -3 for CP, 1 for node pools
resource "aws_subnet" "private" {
  count = local.az_count

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.subnet_availability_zones[count.index]
  tags =  {
    Name                              = "${local.vpc_name}-private-cp-${var.subnet_availability_zones[count.index]}",
    "kubernetes.io/role/internal-elb" = "1"
  }
}



#Public Subnet
resource "aws_subnet" "public" {

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = var.subnet_availability_zones[0]
  map_public_ip_on_launch = true

  tags =  {
    Name                              = "${local.vpc_name}-public-${var.subnet_availability_zones[0]}",
    "kubernetes.io/role/internal-elb" = "1"
  }
}

#Create a route table for the public subnet


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags =  {
    Name = "${local.vpc_name}-public"
  }
}

# Associate the public route table to the public subnet
resource "aws_route_table_association" "public" {
  

  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id = aws_route_table.public.id
  gateway_id     = aws_internet_gateway.this.id

  destination_cidr_block = "0.0.0.0/0"

  timeouts {
    create = "5m"
  }
}
# Reservce an elastic IP address for the NAT gateway_id
resource "aws_eip" "nat" {

  vpc = true

  tags = {
    Name = "${local.vpc_name}-nat-${var.subnet_availability_zones[0]}"
  }
}

# Associate EIP with nat gateway_id

resource "aws_nat_gateway" "this" {
  

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${local.vpc_name}-${var.subnet_availability_zones[0]}"
  }

  depends_on = [aws_internet_gateway.this]
}

# Create Route table entries for the private subnets

resource "aws_route_table" "private" {
  count  = local.az_count
  vpc_id = aws_vpc.this.id

  tags =  {
    Name = "${local.vpc_name}-private-${var.subnet_availability_zones[count.index]}"
  }
}


resource "aws_route_table_association" "private" {
  count = local.az_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

