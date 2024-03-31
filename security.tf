#Public Subnet NACL and Security Group

# #Network ACL
# resource "aws_network_acl" "CLIXX-PUB-NACL" {
#   vpc_id = aws_vpc.main.id
#   depends_on  = [ aws_vpc.main ]

#   egress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 22
#     to_port    = 22
#   }

#   egress {
#     protocol   = "tcp"
#     rule_no    = 200
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 80
#     to_port    = 80
#   }

#   egress {
#     protocol   = "tcp"
#     rule_no    = 300
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 3306
#     to_port    = 3306
#   }  

#   egress {
#     protocol   = "tcp"
#     rule_no    = 400
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 2049
#     to_port    = 2049
#   } 

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 22
#     to_port    = 22
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 200
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 80
#     to_port    = 80
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 300
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 3306
#     to_port    = 3306
#   }  

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 400
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 2049
#     to_port    = 2049
#   }

#   tags = {
#     Name = "Clixx-Pub-NACL"
#   }
# }

# #NACL Association
# resource "aws_network_acl_association" "CLIXX-PUB" {
#   network_acl_id = aws_network_acl.CLIXX-PUB-NACL.id
#   subnet_id      = aws_subnet.CLIXX-PUB.id
# }

# resource "aws_network_acl_association" "CLIXX-PUB2" {
#   network_acl_id = aws_network_acl.CLIXX-PUB-NACL.id
#   subnet_id      = aws_subnet.CLIXX-PUB2.id
# }

#Security Group
resource "aws_security_group" "CLIXX-PUB-SG" {
  vpc_id      = aws_vpc.main.id
  name        = "Clixx-Pub-SG"
  description = "Security group for Application Servers"
  depends_on  = [ aws_vpc.main ]

  ingress {
    description       = "SSH from VPC"
    protocol          = "tcp"
    from_port         = 22
    to_port           = 22
    cidr_blocks       = ["0.0.0.0/0"]
    }

  ingress {
    description       = "Aurora/MySQL"
    protocol          = "tcp"
    from_port         = 3306
    to_port           = 3306
    cidr_blocks       = ["0.0.0.0/0"]
    }

  ingress {
    description       = "EFS mount target"
    protocol          = "tcp"
    from_port         = 2049
    to_port           = 2049
    cidr_blocks       = ["0.0.0.0/0"]
    }

  ingress {
    description       = "HTTP from VPC"
    protocol          = "tcp"
    from_port         = 80
    to_port           = 80
    cidr_blocks       = ["0.0.0.0/0"]
    }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  timeouts {
    delete = "2m"
  }

  lifecycle {
    create_before_destroy = true
  }
}

#######################################################
#######################################################
#Public Subnet NACL and Security Group

#Network ACL
# resource "aws_network_acl" "CLIXX-PRIV-NACL" {
#   vpc_id = aws_vpc.main.id
#   depends_on  = [ aws_vpc.main ]

#   egress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 22
#     to_port    = 22
#   }

#   egress {
#     protocol   = "tcp"
#     rule_no    = 200
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 80
#     to_port    = 80
#   }

#   egress {
#     protocol   = "tcp"
#     rule_no    = 300
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 3306
#     to_port    = 3306
#   } 

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "10.0.0.0/24"
#     from_port  = 22
#     to_port    = 22
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 200
#     action     = "allow"
#     cidr_block = "10.0.0.0/24"
#     from_port  = 80
#     to_port    = 80
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 300
#     action     = "allow"
#     cidr_block = "10.0.0.0/24"
#     from_port  = 3306
#     to_port    = 3306
#   } 

#   tags = {
#     Name = "Clixx-Priv-NACL"
#   }
# }

# #NACL Association
# resource "aws_network_acl_association" "CLIXX-PRIV" {
#   network_acl_id = aws_network_acl.CLIXX-PRIV-NACL.id
#   subnet_id      = aws_subnet.CLIXX-PRIV.id
# }

# resource "aws_network_acl_association" "CLIXX-PRIV2" {
#   network_acl_id = aws_network_acl.CLIXX-PRIV-NACL.id
#   subnet_id      = aws_subnet.CLIXX-PRIV2.id
# }

#Security Group
resource "aws_security_group" "CLIXX-PRIV-SG" {
  vpc_id      = aws_vpc.main.id
  name        = "Clixx-Priv-SG"
  description = "Security group for Backend Servers"
  depends_on  = [ aws_vpc.main ]

  ingress {
    description       = "SSH from VPC"
    protocol          = "tcp"
    from_port         = 22
    to_port           = 22
    cidr_blocks       = ["10.0.0.0/24"]
    }

  ingress {
    description       = "Aurora/MySQL"
    protocol          = "tcp"
    from_port         = 3306
    to_port           = 3306
    cidr_blocks       = ["10.0.0.0/24"]
    }

  ingress {
    description       = "EFS mount target"
    protocol          = "tcp"
    from_port         = 2049
    to_port           = 2049
    cidr_blocks       = ["10.0.0.0/24"]
    }

  ingress {
    description       = "HTTP from VPC"
    protocol          = "tcp"
    from_port         = 80
    to_port           = 80
    cidr_blocks       = ["10.0.0.0/24"]
    }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  timeouts {
    delete = "2m"
  }

  lifecycle {
    create_before_destroy = true
  }
}