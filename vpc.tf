resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

#Two Public Subnets Created
resource "aws_subnet" "CLIXX-PUB" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = var.availability_zone[0]
  depends_on  = [ aws_vpc.main ]

  tags = {
    Name = "Public-Subnet"
  }
}

resource "aws_subnet" "CLIXX-PUB2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  depends_on  = [ aws_vpc.main ]
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "Public-Subnet2"
  }
}

#Two Private Subnets Created
resource "aws_subnet" "CLIXX-PRIV" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.10.0/24"
  availability_zone = var.availability_zone[0]
  depends_on = [ aws_vpc.main ]

  tags = {
    Name = "Private-Subnet"
  }
}

resource "aws_subnet" "CLIXX-PRIV2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.20.0/24"
  availability_zone = var.availability_zone[1]
  depends_on = [ aws_vpc.main ]

  tags = {
    Name = "Private-Subnet-2"
  }
}

resource "aws_db_subnet_group" "CLIXX-PRIV-GRP" {
  name        = "rds_subnet_group"
  subnet_ids  = [aws_subnet.CLIXX-PRIV.id, aws_subnet.CLIXX-PRIV2.id]
  description = "Subnet Group"
  depends_on  = [ aws_vpc.main ]
}

#Internet Gateway Created and Attached to VPC
resource "aws_internet_gateway" "CLIXX-IGW" {
  vpc_id = aws_vpc.main.id
  depends_on  = [ aws_vpc.main ]

  tags = {
    Name = "CLIXX-IGW"
  }
}

# resource "aws_internet_gateway_attachment" "CLIXX-IGW-ATT" {
#   internet_gateway_id = aws_internet_gateway.CLIXX-IGW.id
#   vpc_id              = aws_vpc.main.id
#   depends_on          = [ aws_vpc.main ]
# }

# NAT Gateways, Route Tables
#Create Elastic IP
resource "aws_eip" "CLIXX-NAT-EIP" {
}

resource "aws_nat_gateway" "CLIXX-NAT-PUB1" {
  allocation_id = aws_eip.CLIXX-NAT-EIP.id
  subnet_id     = aws_subnet.CLIXX-PUB.id
  
  tags = {
    Name = "CLIXX-NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_vpc.main, aws_internet_gateway.CLIXX-IGW, aws_eip.CLIXX-NAT-EIP]
}

#Create Elastic IP2
resource "aws_eip" "CLIXX-NAT-EIP2" {
}

resource "aws_nat_gateway" "CLIXX-NAT-PUB2" {
  allocation_id = aws_eip.CLIXX-NAT-EIP2.id
  subnet_id     = aws_subnet.CLIXX-PUB2.id

  tags = {
    Name = "CLIXX-NAT2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_vpc.main, aws_internet_gateway.CLIXX-IGW, aws_eip.CLIXX-NAT-EIP2]
}


# Edit the vpc main route table
# resource "aws_route" "main-vpc-routetable_default" {
#   route_table_id         = aws_vpc.main-vpc.main_route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.main-int-gateway.id
# }

# Public Subnet Route Table
resource "aws_route_table" "CLIXX-TESTSTACKRT1-PUB" {
  vpc_id      = aws_vpc.main.id
  depends_on  = [ aws_vpc.main ]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.CLIXX-IGW.id
  }

  tags = {
    Name = "CLIXX-TESTSTACKRT1"
  }
}

resource "aws_route_table_association" "CLIXX-PUB-RT" {
  subnet_id      = aws_subnet.CLIXX-PUB.id
  route_table_id = aws_route_table.CLIXX-TESTSTACKRT1-PUB.id
}

resource "aws_route_table_association" "CLIXX-PUB-RT2" {
  subnet_id      = aws_subnet.CLIXX-PUB2.id
  route_table_id = aws_route_table.CLIXX-TESTSTACKRT1-PUB.id
}


# Private Subnet Route Table
resource "aws_route_table" "CLIXX-TESTSTACKRT2-PRIV" {
  vpc_id    = aws_vpc.main.id
  depends_on  = [ aws_vpc.main ]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.CLIXX-NAT-PUB1.id
  } 

  tags = {
    Name = "CLIXX-TESTSTACKRT2-PRIV"
  }
}

resource "aws_route_table" "CLIXX-TESTSTACKRT2-PRIV2" {
  vpc_id    = aws_vpc.main.id
  depends_on  = [ aws_vpc.main ]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.CLIXX-NAT-PUB2.id 
  }  

  tags = {
    Name = "CLIXX-TESTSTACKRT2-PRIV2"
  }
}

resource "aws_route_table_association" "CLIXX-PRIV-RT" {
  subnet_id      = aws_subnet.CLIXX-PRIV.id
  route_table_id = aws_route_table.CLIXX-TESTSTACKRT2-PRIV.id
}

resource "aws_route_table_association" "CLIXX-PRIV-RT2" {
  subnet_id      = aws_subnet.CLIXX-PRIV2.id
  route_table_id = aws_route_table.CLIXX-TESTSTACKRT2-PRIV2.id
}

