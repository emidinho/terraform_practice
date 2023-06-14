# Below variables are used for Provider

variable "provider_region" {}

variable "provider_profile" {}

# Below variables are used for VPC

variable "vpc_cidr_block" {}

variable "vpc_name_tag" {}

# Below variables are used for web Public Subnets

variable "web_public_subnet_1_cidr" {}

variable "web_public_subnet_1_az" {}

variable "web_public_subnet_2_cidr" {}

variable "web_public_subnet_2_az" {}

# Below variables are used for App Private Subnets

variable "app_private_subnet_1_cidr" {}

variable "app_private_subnet_1_az" {}

variable "app_private_subnet_2_cidr" {}

variable "app_private_subnet_2_az" {}

# Below variables are used for DB Private Subnets

variable "db_private_subnet_1_cidr" {}

variable "db_private_subnet_1_az" {}

variable "db_private_subnet_2_cidr" {}

variable "db_private_subnet_2_az" {}

# Below variables are used for Public EC2
variable "noofec2" {

}

variable "public_instance_type" {

}

variable "public_ec2_name_tag" {

}

# Below variables are used for Private EC2

variable "private_instance_type" {

}

variable "private_ec2_name_tag" {

}

#  Below variables are used for RDS

variable "subnet_group_name" {}

variable "db_name" {}

variable "instance_class" {} #"db.t3.micro"

variable "username" {}

variable "password" {}
