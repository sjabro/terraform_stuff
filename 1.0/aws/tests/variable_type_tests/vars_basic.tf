variable "string_type" {
  type = string
  default = "string_type"
}

variable "list_of_strings_type" {
  type = list(string)
  default = ["list_string_1","list_string_2"]
}

variable "map" {
  type = map
  default = {
      map_key_1 = "map_value_1"
      map_key_2 = "map_value_2"
  }
}

output "string_var" {
  value = var.string_type
}

output "list_of_strings_var" {
  value = var.list_of_strings_type
}

output "map_var" {
  value = var.map
}