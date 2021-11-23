variable "region" {
    type = string
}

variable "access_key" {
    type = string
}

variable "secret_key" {
    type = string
}

# variable "students" {
#     type = list(string)
#     description = "Comma separate list of student emails. (With quotes)"
#     default = []
# }

variable "morph_version" {
    type = string
    default = "<%=customOptions.morpheusVersion%>"
}

variable "ssh_public_key" {
    type = string
}