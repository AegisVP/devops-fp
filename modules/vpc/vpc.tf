# Creating main VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block # CIDR block for our VPC (e.g., 10.0.0.0/16)
  enable_dns_support   = true               # Enable DNS support in VPC
  enable_dns_hostnames = true               # Enable DNS hostnames for resources in VPC

  tags = {
    Name = "${var.vpc_name}-vpc" # Add a tag that includes the VPC name
  }
}

# Creating public subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)          # Create multiple subnets, the number is defined by the length of the public_subnets list
  vpc_id                  = aws_vpc.main.id                     # Associate each subnet with the VPC created earlier
  cidr_block              = var.public_subnets[count.index]     # CIDR block for the specific subnet from the public_subnets list
  availability_zone       = var.availability_zones[count.index] # Define availability zones for each subnet
  map_public_ip_on_launch = true                                # Automatically assign public IP addresses to instances in the subnet

  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}" # Tag with subnet numbering
  }
}

# Creating private subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)         # Create multiple private subnets, the number is defined by the length of the private_subnets list
  vpc_id            = aws_vpc.main.id                     # Associate each private subnet with the VPC
  cidr_block        = var.private_subnets[count.index]    # CIDR block for the specific subnet from the private_subnets list
  availability_zone = var.availability_zones[count.index] # Define availability zones for each subnet

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}" # Tag with subnet numbering
  }
}

# Creating Internet Gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id     = aws_vpc.main.id                         # Associate Internet Gateway with VPC for internet access
  depends_on = [aws_subnet.private, aws_subnet.public] # Dependency on subnet creation to ensure Gateway is ready after them

  tags = {
    Name = "${var.vpc_name}-igw" # Tag for identifying Internet Gateway
  }
}

