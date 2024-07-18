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
resource "aws_subnet" "main" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.web_subnet_cidr_block
    availability_zone = var.web_subnet_zone

    tags = {
        Name = "Main Subnet"
    }
}