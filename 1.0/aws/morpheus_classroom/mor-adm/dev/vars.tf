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
    default = ["sjabro@morpheusdata.com","sean.jabro@gmail.com"]
}