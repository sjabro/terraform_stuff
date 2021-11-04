locals {
  student_list = {for s in var.students: index(var.students, s) => s}
}