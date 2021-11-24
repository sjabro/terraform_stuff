locals {
  # students = split(",","<%=customOptions.studentEmails%>")
  student_list = {for s in var.students: index(var.students, s) => s}
}