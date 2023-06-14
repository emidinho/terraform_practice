locals {
  public_subnets = [aws_subnet.web_public_subnet_1.id, aws_subnet.web_public_subnet_2.id]

  private_subnets = [aws_subnet.app_private_subnet_1.id, aws_subnet.app_private_subnet_2.id]

  db_private_subnets = [aws_subnet.db_private_subnet_1.id, aws_subnet.db_private_subnet_2.id]
}

# Below code creates public ec2 instances in two public subnets
resource "aws_instance" "public_ec2" {
  count = var.noofec2
  ami           = data.aws_ami.app_ami.id
  instance_type = var.public_instance_type
  tags = {
    Name = var.public_ec2_name_tag
  }

  
  subnet_id = local.public_subnets[count.index]

  user_data = <<-EOF
    #!bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<html><body><h1> Hello Imm B M-W batch </h1></body></html>" > /var/www/html/index.html
  EOF
}

# Below code creates private ec2 instances in two app private subnets
resource "aws_instance" "private_ec2" {
  count = var.noofec2

  ami           = data.aws_ami.app_ami.id
  instance_type = var.private_instance_type
  tags = {
    Name = var.private_ec2_name_tag
  }

  subnet_id = local.private_subnets[count.index]
}

resource "aws_db_subnet_group" "default" {
  name       = var.subnet_group_name
  subnet_ids = local.db_private_subnets

  tags = {
    Name = var.subnet_group_name
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_subnet_group_name = aws_db_subnet_group.default.name
  db_name              = var.subnet_group_name
  engine               = "mysql"
  engine_version       = "8.0.32"
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  skip_final_snapshot  = true
}

