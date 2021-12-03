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
### PRIMITIVE VARS
##################################

### All statements of working ability refer to Morpheus version 5.4.0

# Works with defaults in tf
# Works via user entry in provisioning wizard
# Works with values in cloud profile
variable "string" {
  type = string
}

output "string" {
  value = var.string
}

# Works with defaults in tf
# Works via user entry in provisioning wizard
# Works with values in cloud profile
variable "number" {
  type = number
}

output "number" {
  value = var.number
}

# Works with defaults in tf
# Works via user entry in provisioning wizard
# Works with values in cloud profile
variable "bool" {
  type = bool
}

output "bool" {
  value = var.bool
}

#####################################
### SINGLE LAYER COMPLEX VARS
#####################################

# Works with defaults in tf
# Works via user entry in provisioning wizard
# TODO Does NOT work via cloud profile. Looks to break the parsing.
variable "list_of_strings" {
  type = list(string)
  # default = [ "string_1","string_2","string_3" ]
}

output "list_of_strings" {
  value = var.list_of_strings
}

# Works with defaults in tf

variable "map_of_strings" {
  type = map(string)
#   default = {
#     "string_1" = "This is string 1"
#     "string_2" = "This is string 2"
#   }
}

output "map_of_strings" {
  value = var.map_of_strings
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

#####################################
### MULTI-LAYER COMPLEX VARS
#####################################
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