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

##################################
### BASIC VARS
##################################

variable "string" {
  type = string
  default = "This is a string"
}

output "string" {
  value = var.string
}

variable "number" {
  type = number
  default = 42
}

output "number" {
  value = var.number
}

variable "bool" {
  type = bool
  default = true
}

output "bool" {
  value = var.bool
}

#####################################
### TWO LAYER VARS
#####################################

variable "list_of_strings" {
  type = list(string)
  default = [ "string_1","string_2","string_3" ]
}

output "list_of_strings" {
  value = var.list_of_strings
}

variable "map_of_strings" {
  type = map(string)
  default = {
    "string_1" = "This is string 1"
    "string_2" = "This is string 2"
  }
}

output "map_of_strings" {
  value = var.map_of_strings
}

variable "map_of_any" {
  type = map(any)
  default = {
    "key_1" = "value_1"
    "key_2" = 12 
  }
}

output "map_of_any" {
  value = var.map_of_any
}

variable "map_of_numbers" {
  type = map(number)

  default = {
    "number_1" = 1
    "number_2" = 2
  }
}

output "map_of_numbers" {
  value = var.map_of_numbers
}

variable "map_of_bool" {
  type = map(bool)

  default = {
    "True" = true
    "False" = false
  }
}

output "map_of_bool" {
  value = var.map_of_bool
}

variable "map_of_list_of_strings" {
  type = map(list(string))
  default = {
    "list1" : [ "string1-1","string1-2","string1-3" ]
    "list2" : [ "string2-1","string2-2","string2-3"]
  }
}

output "map_of_list_of_string" {
    value = var.map_of_list_of_strings 
}