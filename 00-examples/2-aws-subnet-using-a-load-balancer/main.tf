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
  region     = "eu-central-1"
  access_key = ""
  secret_key = ""
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Main VPC"
  }
}

# Create a submet
resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
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
  subnet_id      = aws_subnet.web.id
}

# Create a Security Group for the ALB (ALB = Application Load Balancer)
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# Create an Application Load Balancer
resource "aws_lb" "app" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.main.id]

  tags = {
    Name = "app-lb"
  }
}

# Create a Target Group
resource "aws_lb_target_group" "app" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
  }

  tags = {
    Name = "app-tg"
  }
}

# Create a Listener for the ALB
resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = {
    Name = "app-listener"
  }
}

# Create EC2 Instances
resource "aws_instance" "app" {
  count = 2

  ami                         = "ami-0c55b159cbfafe1f0" # replace with your desired AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main.id
  security_groups             = [aws_security_group.instance_sg.name]
  associate_public_ip_address = true

  tags = {
    Name = "app-instance-${count.index + 1}"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /var/www/html/index.html
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
}

# Register EC2 Instances with Target Group
resource "aws_lb_target_group_attachment" "app" {
  count            = 2
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app[count.index].id
  port             = 80
}


# Outputs to make it easier to retrieve the IDs
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.main.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}

output "route_table_id" {
  value = aws_route_table.main.id
}

output "load_balancer_dns" {
  value = aws_lb.app.dns_name
}