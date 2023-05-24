locals {
  public_subnets = [aws_subnet.pubsubnet1.id, aws_subnet.pubsubnet2.id]

  private_subnets = [aws_subnet.privsubnet1.id, aws_subnet.privsubnet2.id]

  dbprivate_subnets = [aws_subnet.dbprivsubnet1.id, aws_subnet.dbprivsubnet2.id]
}


#creating instances in public and private subnets
resource "aws_instance" "pubsn1&2_ec2_1" {
  count = length(var.ec2_name_tag)

  ami                    = var.public_ami_ids[count.index]
  instance_type          = var.public_instance_type[count.index]
  subnet_id              = local.public_subnets[count.index]
  vpc_security_group_ids = [aws_security_group.pubsubnet-sg.id]
  user_data              = file("user_data.sh")

  tags = {
    Name = var.public_ec2_name_tag[count.index]
  }
}

resource "aws_instance" "privsn1&2_ec2_1" {
  count = length(var.ec2_name_tag)

  ami           = var.private_ami_ids[count.index]
  instance_type = var.private_instance_type[count.index]
  subnet_id     = local.private_subnets[count.index]

  tags = {
    Name = var.private_ec2_name_tag[count.index]
  }
}

#creating security groups for instances in public and private subnets
resource "aws_security_group" "pubsubnet-sg" {
  name        = "web-sg"
  description = "Allow http/https/ssh traffic"
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

  ingress {
    description = "allow ssh traffic from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pubsubnet-sg"
  }
}

#creating subnet groups for db
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = local.dbprivate_subnets

  tags = {
    Name = "My DB subnet group"
  }
}

#creating a db in the dbprivsubnets
resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.default
  db_name                = var.db_name
  engine                 = "mysql"
  engine_version         = "8.0.32"
  instance_class         = "db.t3.micro"
  username               = var.username
  password               = var.password
  skip_final_snapshot    = true
  vpc_security_group_ids = []
  port                   = 3306
}
