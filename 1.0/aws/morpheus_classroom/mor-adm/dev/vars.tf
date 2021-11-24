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
    default = ["trainer","student1","student2","student3","student4","student5","student6","student7","student8","student9","student10"]
}

variable "morph_version" {
    type = string
    default = "<%=customOptions.morpheusVersion%>"
}

variable "ssh_public_key" {
    type = string
}