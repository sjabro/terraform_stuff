terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.35.0"
    }
  }
}

provider "aws" {

    alias = "us-east-1"
    region     = "us-east-1"
    access_key = var.access_key
    secret_key = var.secret_key

    default_tags {
    
    tags = {
      Usage = "Morpheus Platform Infrastructure"
    }
  }
}

provider "aws" {

    alias = "us-east-2"
    region     = "us-east-2"
    access_key = var.access_key
    secret_key = var.secret_key

    default_tags {
    
    tags = {
      Usage = "Morpheus Platform Infrastructure"
    }
  }
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for the the VPC"
  default = "172.16.0.0/16"
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

resource "aws_vpc" "vpc_1" {

    provider = aws.us-east-1
    cidr_block = var.vpc_cidr

    tags = {
      "Name" = "us-east-1_vpc"
      "Usage" = "Morpheus Testing"
    }
}

resource "aws_vpc" "vpc_2" {

    provider = aws.us-east-2
    cidr_block = var.vpc_cidr

    tags = {
      "Name" = "us-east-2_vpc"
      "Usage" = "Morpheus Testing"
    }
}