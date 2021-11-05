variable "region" {
    type = string
}

variable "access_key" {
    type = string
}

variable "secret_key" {
    type = string
}

variable "students" {
    type = list(string)
    description = "Comma separate list of student emails. (With quotes)"
    default = ["sjabro@morpheusdata.com","sean.jabro@gmail.com"]
}

variable "morph_version" {
    type = string
    default = "5.2.11-2"
}