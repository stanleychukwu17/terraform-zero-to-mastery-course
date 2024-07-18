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
    cidr_block = var.vpc_cidr_block

    tags = {
        Name = "Dev Env ${var.main_vpc_name}"
    }
}

# Create a subnet
resource "aws_subnet" "web" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.web_subnet_cidr_block
    availability_zone = var.web_subnet_zone

    tags = {
        Name = "Main web Subnet"
    }
}

# Create an inernet gateway for the main vpc
resource "aws_internet_gateway" "my_web_igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        "Name" = "${var.main_vpc_name} IGW"
    }
}

# Create a default route table for the main vpc
resource "aws_default_route_table" "main_default_rt" {
    default_route_table_id = aws_vpc.main.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_web_igw.id
    }

    tags = {
        "Name" = "${var.main_vpc_name} default route table"
    }
}