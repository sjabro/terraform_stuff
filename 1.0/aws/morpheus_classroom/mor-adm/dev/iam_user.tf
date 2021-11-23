data "aws_iam_group" "students" {
  group_name = "students"
}

resource "aws_iam_user" "user" {
  for_each = local.student_list
  # name = each.value
  force_destroy = true
  tags = {
    Name = each.value
  }
}

resource "aws_iam_access_key" "user_key" {
  for_each = local.student_list
  user = aws_iam_user.user[each.key].name
}

resource "aws_iam_user_group_membership" "students" {

  depends_on = [
    aws_iam_user.user,
    data.aws_iam_group.students
  ]
  
  for_each = local.student_list
  user = each.value
  groups = [data.aws_iam_group.students.group_name]
}