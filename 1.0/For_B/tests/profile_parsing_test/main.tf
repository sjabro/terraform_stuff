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
  default = "This is a string"
}

output "string" {
  value = var.string
}

# Works with defaults in tf
# Works via user entry in provisioning wizard
# Works with values in cloud profile
variable "number" {
  type = number
  default = 42
}

output "number" {
  value = var.number
}

# Works with defaults in tf
# Works via user entry in provisioning wizard
# Works with values in cloud profile
variable "bool" {
  type = bool
  default = true
}

output "bool" {
  value = var.bool
}

#####################################
### SINGLE LAYER COMPLEX VARS
#####################################

# Works with defaults in tf
# Works via user entry in provisioning wizard. CAVEAT: User must input utilizing terraform required single line syntax. 
#       - Meaning a comma must exist between each element in the map.
#       - EXAMPLE: This works: [ "string_1","string_2","string_3" ]
#       - EXAMPLE: This does not: [ "string_1" "string_2" "string_3" ]
# TODO Does NOT work via cloud profile. Looks to break the parsing.
variable "list_of_strings" {
  type = list(string)
  default = [ "string_1","string_2","string_3" ]
}

output "list_of_strings" {
  value = var.list_of_strings
}

# Works with defaults in tf
# TODO We need to get the syntax to work similarly across the input methods. 
# Reccomendation is to go with the Hashicorp requirement for single line maps: "Commas are required between key/value pairs for single line maps. A newline between key/value pairs is sufficient in multi-line maps."

# Works via user entry in provisioning wizard. CAVEAT: User must input utilizing terraform required single line syntax. 
#       - Meaning a comma must exist between each element in the map.
#       - EXAMPLE: This works: {"string_1" = "This is string 1","string_2" = "This is string 2"}
#       - EXAMPLE: This does not: {"string_1" = "This is string 1" "string_2" = "This is string 2"}
# Works via cloud profile. CAVEAT: Must be entered in single line syntax WITHOUT the comma or only the first element is deployed
#       - This is the exact opposite of the user input. 
#       - EXAMPLE: This works: {"string_1" = "This is string 1" "string_2" = "This is string 2"}
#       - EXAMPLE: This does not: {"string_1" = "This is string 1","string_2" = "This is string 2"}    
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

# Works with defaults in tf
# TODO We need to get the syntax to work similarly across the input methods. 
# Reccomendation is to go with the Hashicorp requirement for single line maps: "Commas are required between key/value pairs for single line maps. A newline between key/value pairs is sufficient in multi-line maps."

# Works via user entry in provisioning wizard. CAVEAT: User must input utilizing terraform required single line syntax. 
#       - Meaning a comma must exist between each element in the map.
#       - EXAMPLE: This works: {"number_1" = 1,"number_2" = 2}
#       - EXAMPLE: This does not: {"number_1" = 1 "number_2" = 2}
# Works via cloud profile. CAVEAT: Must be entered in single line syntax WITHOUT the comma or only the first element is deployed
#       - This is the exact opposite of the user input. 
#       - EXAMPLE: This works: {"number_1" = 1 "number_2" = 2}
#       - EXAMPLE: This does not: {"number_1" = 1,"number_2" = 2}
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

# TODO Does NOT work via terraform defaults. Only first element created. 
# TODO We need to get the syntax to work similarly across the input methods. 
# Reccomendation is to go with the Hashicorp requirement for single line maps: "Commas are required between key/value pairs for single line maps. A newline between key/value pairs is sufficient in multi-line maps."

# Works via user entry in provisioning wizard. CAVEAT: User must input utilizing terraform required single line syntax. 
#       - Meaning a comma must exist between each element in the map.
#       - EXAMPLE: This works: {"True" = true, "False" = false}
#       - EXAMPLE: This does not: {"True" = true "False" = false}
# TODO Does NOT work via cloud profile. Only deploys first element in the map regardless of syntax
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

# Works with defaults in tf
# TODO We need to get the syntax to work similarly across the input methods. 
# Reccomendation is to go with the Hashicorp requirement for single line maps: "Commas are required between key/value pairs for single line maps. A newline between key/value pairs is sufficient in multi-line maps."

# Works via user entry in provisioning wizard. CAVEAT: User must input utilizing terraform required single line syntax. 
#       - Meaning a comma must exist between each element in the map.
#       - EXAMPLE: This works: {"list1" : [ "string1-1","string1-2","string1-3" ],"list2" : [ "string2-1","string2-2","string2-3"]}
#       - EXAMPLE: This does not: {"list1" : [ "string1-1" "string1-2" "string1-3" ] "list2" : [ "string2-1" "string2-2" "string2-3"]}
# TODO Does NOT work via cloud code regardless of syntax. Probably tied to the parsing error for list os string
variable "map_of_list_of_strings" {
  type = map(list(string))

  # default = {
  #   "list1" : [ "string1-1","string1-2","string1-3" ]
  #   "list2" : [ "string2-1","string2-2","string2-3"]
  # }
}

output "map_of_list_of_string" {
    value = var.map_of_list_of_strings 
}
