locals {
  students_given = ["<%=customOptions.studentEmails%>"]
  student_trim = trim(local.students_given, "\"")
  students = "${local.student_trim}"
  student_list = {for s in local.students: index(var.students, s) => s}
}