variable "env" {
  description = "E.g. dev or prod."
  type = string
  default = "dev"
}

variable "aws_region" {
  description = "AWS region to build in."
  type = string
}

variable "private_s3_bucket_name" {
  description = "Name of private s3 bucket."
  type = string
}
