resource "aws_instance" "ec2" {
  ami           = local.amis[var.region]
  instance_type = "t2.micro"

}

output "aws_instance" {
  value = aws_instance.ec2
}