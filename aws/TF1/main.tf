terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.37.0"
    }
  }
}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  
  tags = {
    "Name" = "dev"
  }
}

resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "other region"

  tags = {
    "Name" = "dev-public-1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "other region"

  tags = {
    "Name" = "dev-public-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "dev-gw"
  }
}

resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.vpc.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "dev-public"
  }
}

resource "aws_route_table_association" "route_sub_1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.route_public.id
}

resource "aws_route_table_association" "route_sub_2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.route_public.id
}

resource "aws_instance" "public_inst_1" {
  ami           = "ami-0c1a7f89451184c8b"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.public-1.id}"
  key_name      = var.key_name

  tags = {
    "Name" = "public_inst_1"
  }
}

resource "aws_instance" "public_inst_2" {
  ami           = "ami-0c1a7f89451184c8b"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.public-2.id}"
  key_name      = var.key_name

  tags = {
    "Name" = "public_inst_2"
  }
}