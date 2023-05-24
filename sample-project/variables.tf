#vpc variables
variable "vpc_cidr_block" {}

variable "vpc_name_tag" {}

#provider variables
variable "provider_region" {}

variable "provider_profile" {}

#pubsubnet variables
variable "pubsubnet1_cidr_block" {}

variable "pubsubnet1AZ" {}

variable "pubsubnet1_name_tag" {}

variable "pubsubnet2_cidr_block" {}

variable "pubsubnet2AZ" {}

variable "pubsubnet2_name_tag" {}

#privsubnet variables
variable "privsubnet1_cidr_block" {}

variable "privsubnet1AZ" {}

variable "privsubnet1_name_tag" {}

variable "privsubnet2_cidr_block" {}

variable "privsubnet2AZ" {}

variable "privsubnet2_name_tag" {}

#dbprivsubnet variables
variable "dbprivsubnet1_cidr_block" {}

variable "dbprivsubnet1AZ" {}

variable "dbprivsubnet1_name_tag" {}

variable "dbprivsubnet2_cidr_block" {}

variable "dbprivsubnet2AZ" {}

variable "dbprivsubnet2_name_tag" {}

#public ec2 variables
variable "public_ami_ids" {}
variable "public_instance_type" {}
variable "public_ec2_name_tag" {}

#private ec2 variables
variable "private_ami_ids" {}
variable "private_instance_type" {}
variable "private_ec2_name_tag" {}

#db variables
variable "db_name" {}
variable "username" {}
variable "password" {}
