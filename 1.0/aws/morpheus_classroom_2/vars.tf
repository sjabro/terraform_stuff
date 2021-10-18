variable "region" {
    type = string
}

variable "access_key" {
    type = string
}

variable "secret_key" {
    type = string
}

variable "vpc_root_cidr" {
    type = string
    default = "172.30.0.0/24"
}

variable "students" {
    type = list(string)
    default = ["sjabro@morpheusdata.com","sean.jabro@gmail.com"]
}