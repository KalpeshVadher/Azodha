variable "aws_region" {
  default = "ap-south-1"
}

variable "vpc_id" {}

variable "subnet_ids" {
  type = list(string)
}

variable "ecr_repo_url" {}

variable "sg_id" {}
