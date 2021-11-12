locals {
  students = ["sean.jabro@outlook.com","sjabro@morpheusdata.com"]
  student_list = {for s in local.students: index(var.students, s) => s}
}