variable "aws_region" {
  description = "AWS region jahan resources deploy honge"
  type        = string
  default     = "ap-south-1"
}

variable "docker_image" {
  description = "Docker Hub image for ECS container"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 2
}
