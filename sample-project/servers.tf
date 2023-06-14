locals {
  public_subnets = [aws_subnet.pubsubnet1.id, aws_subnet.pubsubnet2.id]

  private_subnets = [aws_subnet.privsubnet1.id, aws_subnet.privsubnet2.id]

  dbprivate_subnets = [aws_subnet.dbprivsubnet1.id, aws_subnet.dbprivsubnet2.id]

  project_tags = {
    Name  = "server"
    Owner = "emidio"
    email = "emidioalemnju@gmail.com"
    time  = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  }
}

#creating instances in public and private subnets
resource "aws_instance" "pub_ec2" {
  count = length(var.public_ami_ids)

  ami                    = var.public_ami_ids[count.index]
  instance_type          = var.public_instance_type[count.index]
  subnet_id              = local.public_subnets[count.index]
  vpc_security_group_ids = [aws_security_group.pub_server-sg.id]
  user_data              = file("user_data.sh")

  tags = {
    Name = local.project_tags
  }
}

resource "aws_instance" "priv_ec2" {
  count = length(var.private_ami_ids)

  ami                    = var.private_ami_ids[count.index]
  instance_type          = var.private_instance_type[count.index]
  subnet_id              = local.private_subnets[count.index]
  vpc_security_group_ids = [aws_security_group.priv_server-sg.id]

  tags = {
    Name = local.project_tags
  }
}

#creating security groups for instances in public and private subnets
resource "aws_security_group" "pub_server-sg" {
  name        = "pub_server-sg"
  description = "Ingress sg for pubec2 allows http/https/ssh traffic"
  vpc_id      = aws_vpc.my_vpc.id
  dynamic "ingress" {
    for_each = [80, 443, 22]
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name = "pubsubnet-sg"
  }
}

resource "aws_security_group" "priv_server-sg" {
  name        = "priv_server-sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description     = "allow ssh traffic from internet"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.pubsubnet-sg.id]
  }

  tags = {
    Name = "privsubnet_sg"
  }
}

#creating db subnet groups 
resource "aws_db_subnet_group" "db_sn_gp" {
  name       = "DB subnet group"
  subnet_ids = local.dbprivate_subnets

  tags = {
    Name = "My DB subnet group"
  }
}

#creating db security group
resource "aws_security_group" "db_sg" {
  name        = "mysql-db-sg"
  description = "Security group for MySQL database"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow access from anywhere (not recommended for production)
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow outbound traffic to anywhere (modify as per your requirements)
  }
}

#creating a db in the dbprivsubnets
resource "aws_db_instance" "project_db" {
  allocated_storage      = 10
  storage_type           = "gp2"
  db_subnet_group_name   = aws_db_subnet_group.db_sn_gp.name
  publicly_accessible    = true
  engine                 = "mysql"
  engine_version         = "8.0.32"
  instance_class         = "db.t2.micro"
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}
