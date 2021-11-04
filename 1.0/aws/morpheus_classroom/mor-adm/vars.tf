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

variable "os" {
    type = string
    default = "ubuntu"
    validation {
      condition = anytrue([
          var.os == "ubuntu",
          var.os == "amazon_linux"
      ])
      error_message = "Must be a valid OS. Valid options are ubuntu or amazon_linux."
    }
}