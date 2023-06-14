#vpc variables
variable "vpc_cidr_block" {}
variable "vpc_name_tag" {}

#provider variables
variable "provider_region" {}
variable "provider_profile" {}

#pubsubnet variables
variable "pubsubnet1_cidr_block" {}
variable "pubsubnet1AZ" {}
variable "pubsubnet2_cidr_block" {}
variable "pubsubnet2AZ" {}

#privsubnet variables
variable "privsubnet1_cidr_block" {}
variable "privsubnet1AZ" {}
variable "privsubnet2_cidr_block" {}
variable "privsubnet2AZ" {}

#dbprivsubnet variables
variable "dbprivsubnet1_cidr_block" {}
variable "dbprivsubnet1AZ" {}
variable "dbprivsubnet2_cidr_block" {}
variable "dbprivsubnet2AZ" {}

#public ec2 variables
variable "public_ami_ids" {
  default = { 0 = "ami-09988af04120b3591", 1 = "ami-002070d43b0a4f171" }
}
variable "public_instance_type" {
  default = ["t2.micro", "t2.medium"]
}

#private ec2 variables
variable "private_ami_ids" {
  default = { 0 = "ami-09988af04120b3591", 1 = "ami-002070d43b0a4f171" }
}
variable "private_instance_type" {
  default = ["t2.micro", "t2.medium"]
}

#db variables
variable "db_name" {}
variable "username" {}
variable "password" {}
