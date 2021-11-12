locals {
  students_given = ["<%=customOptions.studentEmails%>"]
  students = trim(local.students_given, "\"")
  # students = "${local.student_trim}"
  student_list = {for s in local.students: index(var.students, s) => s}
}