variable "instance_ips" {
  type = list(string)
  default = ["172.16.0.5"]
}

variable "region" {
    type = string
}

variable "access_key" {
    type = string
}

variable "secret_key" {
    type = string
}