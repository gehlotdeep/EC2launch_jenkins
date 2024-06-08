variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "volume_size" {
  description = "Instance volume"
  type        = number
}

variable "region" {
  description = "The AWS region to deploy the instance"
  type        = string
}

variable "tags" {
  description = "Describe your ec2 instance name"
  type        = string
}

variable "ami" {
  description = "your instance AMI id"
  type        = string
}

variable "availability_zone" {
  description = "your availability_zone"
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string

}


variable "text1" {
  description = "local test"
  type        = string
}

variable "my_security_group" {
  description = "Please specify the security group name"
  type        = string
  /* default = "my-security-group" */
}

variable "my_vpc" {
  description = "name your VPC"
  type        = string
}

terraform {
  backend "s3" {
    bucket         = "deepakgehlot"
    region         = "eu-west-2"
    key            = "resource.tf"
    dynamodb_table = "new-table"
  }
}

variable "AWS_ACCESS_KEY_ID" {
  description = "The AWS access key ID"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "The AWS secret access key"
  type        = string
}

