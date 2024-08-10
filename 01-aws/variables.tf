variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  description = "The CIDR block for the VPC"
  type        = string
}

variable "main_vpc_name" {

}

variable "web_subnet_cidr_block" {
  default     = "10.0.10.0/16"
  description = "The CIDR block for the web subnet"
  type        = string
}

variable "web_subnet_zone" {
  description = "the availability zone for the web subnet"
}

variable "my_ip_address" {
  description = "my IP address, if you want to restrict access"
  type        = string
}

variable "public_ip_address" {
  description = "public IP address, should allow everyone to be able to access the web server"
  type        = string
}