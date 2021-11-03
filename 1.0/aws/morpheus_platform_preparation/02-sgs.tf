resource "aws_security_group" "rds-sg" {
  name = "Morpheus DB SG"
  description = "RDS communications"
  vpc_id = aws_vpc.main.id

  ingress = [ {
    cidr_blocks = [aws_vpc.main.cidr_block ]
    description = "Allow MYSql in"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  } ]
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
    "Name" = "Morpheus DB SG"
  }
}

resource "aws_security_group" "app_nodes" {
  name = "Morpheus App Node Security Group"
  description = "Allows communication in for Morpheus app nodes"
  vpc_id = aws_vpc.main.id

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
    cidr_blocks = [ "0.0.0.0/0" ]
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
    "Name" = "Morpheus App Node Security Group"
  }
}

resource "aws_security_group" "nfs" {
  name = "Morpheus NFS SG"
  description = "NFS communications"
  vpc_id = aws_vpc.main.id

  ingress = [ {
    cidr_blocks = [aws_vpc.main.cidr_block ]
    description = "Allow NFS"
    from_port = 111
    to_port = 111
    protocol = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  },
  {
    cidr_blocks = [aws_vpc.main.cidr_block ]
    description = "Allow NFS"
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  },
  {
    cidr_blocks = [aws_vpc.main.cidr_block ]
    description = "Allow NFS"
    from_port = 111
    to_port = 111
    protocol = "udp"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  },
  {
    cidr_blocks = [aws_vpc.main.cidr_block ]
    description = "Allow NFS"
    from_port = 2049
    to_port = 2049
    protocol = "udp"
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
    "Name" = "Morpheus NFS SG"
  }   
}