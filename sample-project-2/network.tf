# Below code will create a VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name_tag
  }
}


# Subnets (2 Az1 & Az2)
# 2 public - web
# 2 private - app
# 2 private - db

# Below code will create two public subnets in Different AZs
resource "aws_subnet" "web_public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.web_public_subnet_1_cidr
  availability_zone       = var.web_public_subnet_1_az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name_tag}-pub-sub-1"
  }
}

resource "aws_subnet" "web_public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.web_public_subnet_2_cidr
  availability_zone       = var.web_public_subnet_2_az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name_tag}-pub-sub-2"
  }
}

# Below code will create two private subnets for APP in Different AZs
resource "aws_subnet" "app_private_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.app_private_subnet_1_cidr
  availability_zone       = var.app_private_subnet_1_az
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name_tag}-pri-sub-1"
  }
}

resource "aws_subnet" "app_private_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.app_private_subnet_2_cidr
  availability_zone       = var.app_private_subnet_2_az
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name_tag}-pri-sub-2"
  }
}


# Below code will create two private subnets for DB in Different AZs
resource "aws_subnet" "db_private_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.db_private_subnet_1_cidr
  availability_zone       = var.db_private_subnet_1_az
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name_tag}-db-sub-1"
  }
}

resource "aws_subnet" "db_private_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.db_private_subnet_2_cidr
  availability_zone       = var.db_private_subnet_2_az
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name_tag}-db-sub-2"
  }
}

# below code is for IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name_tag}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name_tag}-public-rt"
  }
}

# Below code is to do the RT attachment 
resource "aws_route_table_association" "prt1" {
  subnet_id      = aws_subnet.web_public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "prt2" {
  subnet_id      = aws_subnet.web_public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_security_group" "demo_sg" {
  name = "sample-sg-imm-m-w"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.demo_sg.id]
  subnets            = [aws_subnet.web_public_subnet_1.id, aws_subnet.web_public_subnet_2.id]

}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-example.arn
  }
}

resource "aws_lb_target_group" "alb-example" {
  name        = "tf-example-lb-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "test" {
  count=var.noofec2
  target_group_arn = aws_lb_target_group.alb-example.arn
  target_id        = aws_instance.public_ec2[count.index].id
  port             = 80
}