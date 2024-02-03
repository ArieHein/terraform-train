resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/18"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "value"
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "value"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.aws_vpc.id
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.aws_vpc.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route.id
}