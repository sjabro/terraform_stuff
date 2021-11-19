terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.35.0"
    }
  }
}

provider "aws" {
}

variable "list_of_strings" {
  type = list(string)
}

variable "map_of_any" {
  type = map(any)
}

output "list_of_strings" {
  value = var.list_of_strings
}

output "map_of_any" {
  value = var.map_of_any
}