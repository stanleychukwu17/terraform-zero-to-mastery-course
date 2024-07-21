terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Configure the AWS Provider
provider "aws" {
    region = "eu-central-1"
    access_key = ""
    secret_key = ""
}

# Create a VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "Main VPC"
    }
}

# Create a submet
resource "aws_subnet" "web" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-central-1a"

    tags = {
        Name = "Web Subnet"
    }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "web_igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "Web IGW"
    }
}

# Create a route table
resource "aws_route_table" "web_rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.web_igw.id
    }

    tags = {
        Name = "Web Route Table"
    }
}

# Create a route table association
resource "aws_route_table_association" "web_rt_assoc" {
    route_table_id = aws_route_table.web_rt.id
    subnet_id = aws_subnet.web.id
}