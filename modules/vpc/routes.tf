# Creating route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id # Associate the route table with our VPC

  tags = {
    Name = "${var.vpc_name}-public-rt" # Tag for the route table
  }
}

# Adding route for internet access through Internet Gateway
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id   # ID of the route table
  destination_cidr_block = "0.0.0.0/0"                 # All IP addresses
  gateway_id             = aws_internet_gateway.igw.id # Specify Internet Gateway as the exit
}

# Associating route table with public subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets) # Associating each subnet
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
