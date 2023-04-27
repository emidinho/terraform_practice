resource "aws_instance" "ec2instance" {
  ami               = "ami-02396cdd13e9a1257"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "linux-keypair"
  subnet_id         = "subnet-01345df02fbb7abcb"
  vpc_security_group_ids = ["sg-0b426fb422fb5038e"]
  associate_public_ip_address = true
  iam_instance_profile = "EC2-AmazonS3ReadOnlyAccess"
  monitoring = false
  tenancy = "default"
  user_data  = <<EOF
#!/bin/bash
sudo su
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
wget -P ../../var/www/html https://s3.amazonaws.com/emidinho.net/index.html

EOF
  ebs_block_device {
    delete_on_termination = true
    device_name = "/dev/xvda"
    encrypted = false
    volume_type = "gp2"
    volume_size = "8"
    tags = {
      "Name" = "server1_ebs"
    }
  }

  tags = {
    Name      = "server1-tf"
    Createdby = "Dev"
    Owner     = "Emidio"
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "emibucket-tf"

  tags = {
    Name = "My bucket"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}
