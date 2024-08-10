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

}
