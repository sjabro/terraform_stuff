terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.35.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type =string
}

variable "region" {
  type =string
}

variable "size_xlarge" {

  type        = map(string)

  description = "configuration settings for implementation type: micro"

  default = {

    taskCPU  = 4096

    taskMEM  = 8192

    cntnrCPU = 2048

    cntnrMEM = 4096

    srvcCNT  = 1

  }

}

output "size_xlarge" {
  value = var.size_xlarge
}