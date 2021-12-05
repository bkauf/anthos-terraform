terraform {
  required_version = ">= 0.12.23"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

locals {
  vpc_name = "${var.anthos_prefix}-anthos-vpc"
  az_count = length(var.subnet_availability_zones)
}

# Create a VPC
# https://cloud.google.com/anthos/clusters/docs/multi-cloud/aws/how-to/create-aws-vpc
# Step 1 & 2 from doc
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.anthos_prefix}-anthos-vpc"
  }
}

# Create sample VPC
# https://cloud.google.com/anthos/clusters/docs/multi-cloud/aws/how-to/create-aws-vpc
# Create 4 private subnets and 1 public subnet. 
# Three private subnets are used by the Anthos on AWS control planes (running in three zones)
# and one or more private subnets is used by node pools.
# The public subnets is used by the load balancers for associated services.

# Create 3 control plane subnets
# https://cloud.google.com/anthos/clusters/docs/multi-cloud/aws/how-to/create-aws-vpc
# Step 1
resource "aws_subnet" "private_cp" {
  count             = local.az_count
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.cp_private_subnet_cidr_blocks[count.index]
  availability_zone = var.subnet_availability_zones[count.index]
  tags = {
    Name                              = "${local.vpc_name}-private-cp-${var.subnet_availability_zones[count.index]}",
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Step 2, 3
# Create a public subnet for the NAT gateway.
# Mark the subnet as public.
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.subnet_availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name                              = "${local.vpc_name}-public-${var.subnet_availability_zones[0]}",
    "kubernetes.io/role/internal-elb" = "1"
  }
}
# Step 4
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = local.vpc_name
  }
}

# Step 5
# Create an internet gateway so the public subnets have access to the internet.
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
  timeouts {
    create = "5m"
  }
}

# Configure the routing table
# https://cloud.google.com/anthos/clusters/docs/multi-cloud/aws/how-to/create-aws-vpc#configure_the_routing_tables_for_private_subnets
# Step 1
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.vpc_name}-public"
  }
}
# Step 2
# Associate the public route table to the public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Step 3 configured in "public_internet_gateway"
# Step 4
# Reservce an elastic IP address for the NAT gateway_id
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "${local.vpc_name}-nat-${var.subnet_availability_zones[0]}"
  }
}
# Step 5
# Associate EIP with nat gateway_id
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "${local.vpc_name}-${var.subnet_availability_zones[0]}"
  }
  depends_on = [aws_internet_gateway.this]
}
# Step 6
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${local.vpc_name}-private"
  }
}
# Step 7
resource "aws_route_table_association" "private" {
  count          = local.az_count
  subnet_id      = aws_subnet.private_cp[count.index].id
  route_table_id = aws_route_table.private.id
}
# Step 8
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
  timeouts {
    create = "5m"
  }
}

# Create node pool subnets
# Step 1
resource "aws_subnet" "private_np" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.np_private_subnet_cidr_blocks[0]
  availability_zone = var.subnet_availability_zones[0]
  tags = {
    Name                              = "${local.vpc_name}-private-np-${var.subnet_availability_zones[0]}",
    "kubernetes.io/role/internal-elb" = "1"
  }
}
# Step 2
resource "aws_route_table_association" "np_private" {
  subnet_id      = aws_subnet.private_np.id
  route_table_id = aws_route_table.private.id
}







