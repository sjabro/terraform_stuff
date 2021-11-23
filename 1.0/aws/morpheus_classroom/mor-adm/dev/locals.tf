locals {
  students = split(",","<%=customOptions.studentEmails%>")
  student_list = {for s in local.students: index(local.students, s) => s}
}