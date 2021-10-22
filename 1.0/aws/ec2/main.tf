resource "aws_instance" "ec2" {
  ami           = local.amis[var.region]
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.net_if.id
    device_index         = 0
  }
}

output "aws_instance" {
  value = aws_instance.ec2
}