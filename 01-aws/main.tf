terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
    access_key = ""
    secret_key = ""
}

resource "aws_vpc" "main" {
    cidr_block = "10.00.0.0/16"
}