#!/bin/bash
sudo su
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
wget -P ../../var/www/html https://s3.amazonaws.com/emidinho.net/index.html
