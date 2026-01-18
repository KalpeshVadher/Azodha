variable "aws_region" {
  default = "ap-south-1"
}

variable "vpc_id" {
  description = "Existing VPC ID"
}

variable "subnet_ids" {
  description = "Public subnets for ALB & ECS"
  type        = list(string)
}

variable "docker_image" {
  description = "Docker image (ECR or DockerHub)"
}
