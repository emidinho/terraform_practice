locals {
  public_subnets = [aws_subnet.pubsubnet1.id, aws_subnet.pubsubnet2.id]
}

#creating a load balancer
resource "aws_lb" "my_alb" {
  name               = "My-alb-tf"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = local.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "My_alb_tf"
  }
}

#creating laod balancer target group
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-alb-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.my_vpc.id
  health_check {
    path ="/"
    protocol = "HTTP"
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 5
    interval = 15
    matcher = "200"
  }
}

#creating target group attachment
resource "aws_lb_target_group_attachment" "ec2_targets" {
  count = length(aws_instance.pub_ec2_1)
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.pub_ec2_1[count.index].id
}

#creating alb listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}
