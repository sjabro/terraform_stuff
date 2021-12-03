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
  default = [ "string_1","string_2","string_3" ]
}

variable "map_of_any" {
  type = map(any)
  default = {
    "key_1" = "value_1",
    "key_2" = 12 
  }
}

variable "map_of_list_of_strings" {
  type = map(list(string))
  default = {
    "list1" = [ "string1-1","string1-2","string1-3" ]
    "list2" = [ "string2-1","string2-2","string2-3"]
  }
}

output "list_of_strings" {
  value = var.list_of_strings
}

output "map_of_any" {
  value = var.map_of_any
}

output "map_of_list_of_strings" {
  value = var.map_of_list_of_strings
}