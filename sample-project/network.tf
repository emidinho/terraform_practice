#creating a vpc
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name_tag
  }
}

#creating a pub subnets
resource "aws_subnet" "pubsubnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.pubsubnet1_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.pubsubnet1AZ

  tags = {
    Name = var.pubsubnet1_name_tag
  }
}

resource "aws_subnet" "pubsubnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.pubsubnet2_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.pubsubnet2AZ

  tags = {
    Name = var.pubsubnet2_name_tag
  }
}

#creating a priv subnets (app tier)
resource "aws_subnet" "privsubnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.privsubnet1_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = var.privsubnet1AZ

  tags = {
    Name = var.privsubnet1_name_tag
  }
}

resource "aws_subnet" "privsubnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.privsubnet2_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = var.privsubnet2AZ

  tags = {
    Name = var.privsubnet2_name_tag
  }
}

#creating a priv subnets (db tier)
resource "aws_subnet" "dbprivsubnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.dbprivsubnet1_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = var.dbprivsubnet1AZ

  tags = {
    Name = var.dbprivsubnet1_name_tag
  }
}

resource "aws_subnet" "dbprivsubnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.dbprivsubnet2_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = var.dbprivsubnet2AZ

  tags = {
    Name = var.dbprivsubnet2_name_tag
  }
}

#creating igw for the vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name_tag}-igw"
  }
}

#creating private NAT GW
resource "aws_nat_gateway" "private_NAT_GW" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.privsubnet1.id
}

#creating pub route table
resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name_tag}-public-RT"
  }
}

#public subnets route table association
resource "aws_route_table_association" "pubsubnet1assoc" {
  subnet_id      = aws_subnet.pubsubnet1.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "pubsubnet2assoc" {
  subnet_id      = aws_subnet.pubsubnet2.id
  route_table_id = aws_route_table.public_RT.id
}

#creating priv route table(gateway_id = NAT GW)
resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.private_NAT_GW.id
  }

  tags = {
    Name = "${var.vpc_name_tag}-private-RT"
  }
}

#private subnets route table association
resource "aws_route_table_association" "privsubnet1assoc" {
  subnet_id      = aws_subnet.privsubnet1.id
  route_table_id = aws_route_table.private_RT.id
}

resource "aws_route_table_association" "pubsubnet2assoc" {
  subnet_id      = aws_subnet.privsubnet2.id
  route_table_id = aws_route_table.private_RT.id
}

#creating security groups
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow https/http/ssh inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "allow https traffic from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow http traffic from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_sg"
  }
}

resource "aws_security_group" "ssh_sg" {
  name        = "ssh_sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id
  
  ingress {
    description = "allow ssh traffic from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh_sg"
  }
}

