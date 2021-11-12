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
#     default = ["<%=customOptions.studentEmails%>"]
# }

variable "morph_version" {
    type = string
    default = "5.2.11-2"
}