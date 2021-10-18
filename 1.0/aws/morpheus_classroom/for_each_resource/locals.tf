locals {
  student_count = {for u in var.students: index(var.students, u) => u}
  time = formatdate("MM-DD-YYYY", timestamp())
  amis = {
    "us-east-1" = "ami-09e67e426f25ce0d7"
    "us-east-2" = "ami-0443305dabd4be2bc"
    "us-west-1" = "ami-0d382e80be7ffdae5"
    "us-west-2" = "ami-03d5c68bab01f3496"
    "eu-central-1" = "ami-05f7491af5eef733a"
    "eu-west-1" = "ami-0a8e758f5e873d1c1"
    "eu-west-2" = "ami-0194c3e07668a7e36"
    "eu-west-3" = "ami-0f7cd40eac2214b37"
  }
}