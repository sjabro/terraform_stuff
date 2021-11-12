locals {
  # students = trim(["<%=customOptions.studentEmails%>"])
  # students = trim(local.students_given, "\"")
  # students = "${local.student_trim}"
  student_list = {for s in var.students: index(var.students, s) => s}
}