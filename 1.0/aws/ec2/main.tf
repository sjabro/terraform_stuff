resource "aws_network_interface" "main" {
    subnet_id = data.aws_subnet.main.id
}

resource "aws_instance" "main" {
  ami           = local.amis[var.region]
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.main.id
    device_index         = 0
  }
}

output "aws_instance" {
  value = aws_instance.main
}