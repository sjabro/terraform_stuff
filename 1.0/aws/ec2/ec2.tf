variable "instance_ips" {
  type = list(string)
  default = ["172.16.0.5"]
}

resource "aws_network_interface" "net_if" {
  subnet_id   = aws_subnet.subnet.id
  private_ips = var.instance_ips

}

resource "aws_instance" "ec2" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.net_if.id
    device_index         = 0
  }
}

output "aws_instance" {
  value = aws_instance.ec2
}