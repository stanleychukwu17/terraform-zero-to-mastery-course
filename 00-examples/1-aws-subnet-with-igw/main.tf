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

# Create a subnet
resource "aws_subnet" "web" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.10.0/24"
    availability_zone = "eu-central-1a"

    tags = {
        Name = "Main Web Subnet"
    }
}

# Create an internet gateway
resource "aws_internet_gateway" "web_igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "Main Web IGW"
    }
}

# Create a route table
resource "aws_route_table" "main" {
    vpc_id = aws_vpc.main.id

    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.web_igw.id
    }

    tags = {
        Name = "Main Route Table"
    }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "main" {
    subnet_id = aws_subnet.web.id
    route_table_id = aws_route_table.main.id
}

# Outputs to make it easier to retrieve the IDs
output "vpc_id" {
    value = aws_vpc.main.id
}

output "subnet_id" {
    value = aws_subnet.web.id
}

output "igw_id" {
    value = aws_internet_gateway.web_igw.id
}

output "route_table_id" {
    value = aws_route_table.main.id
}