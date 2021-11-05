############################################################################
# SG Vars
############################################################################

variable "ssh_ingress_cidrs" {
    type = list(string)
    description = "CIDRs allowed to access this system over SSH"
    default = ["0.0.0.0/0"]
}

resource "aws_security_group" "app_nodes" {
  for_each = local.student_list
  name = "Morpheus App Node Security Group"
  description = "Allows communication in for Morpheus app nodes"
  vpc_id = aws_vpc.main[each.key].id

  ingress = [ 
    {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow HTTPS in"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
    },
    {
    cidr_blocks = var.ssh_ingress_cidrs
    description = "Allow SSH in"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
    }
   ]
  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow ALL Out"
    from_port = 0
    to_port = 0
    protocol = "-1"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  } ]
  tags = {
    "Name" = "${each.value}-sg"
  }
}