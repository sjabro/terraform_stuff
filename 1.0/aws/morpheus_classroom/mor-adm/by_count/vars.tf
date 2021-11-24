variable "region" {
    type = string
}

variable "access_key" {
    type = string
}

variable "secret_key" {
    type = string
}

variable "instance_count" {
    type = number
    description = "Count of systems including trainer"
    default = 11
}

variable "morph_version" {
    type = string
    default = "<%=customOptions.morpheusVersion%>"
}

variable "ssh_public_key" {
    type = string
}