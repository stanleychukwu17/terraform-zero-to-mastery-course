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
    cidr_block = "10.00.0.0/16"

    tags = {
        Name = "Main VPC"
    }
}

# Create a subnet
resource "aws_subnet" "main" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "eu-central-1a"

    tags = {
        Name = "Main Subnet"
    }
}