data "aws_iam_group" "students" {
  group_name = "students"
}

resource "aws_iam_user" "user" {
  count = var.instance_count
  name = "mor-adm-${var.region}-${count.index}"
  force_destroy = true
}

resource "aws_iam_access_key" "user_key" {
  count = var.instance_count
  user = aws_iam_user.user[count.index].name
}

resource "aws_iam_user_group_membership" "students" {
  
  count = var.instance_count
  user = aws_iam_user.user[count.index].name
  groups = [data.aws_iam_group.students.group_name]

  depends_on = [
  aws_iam_user.user,
  data.aws_iam_group.students
  ]
}