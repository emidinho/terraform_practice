#vpc variables
vpc_cidr_block = "10.2.0.0/16"
vpc_name_tag   = "tf_project_vpc"

#provider variables
provider_region  = "us-east-1"
provider_profile = "default"

#pubsubnet variables
pubsubnet1_cidr_block = "10.2.1.0/24"
pubsubnet1AZ          = "us-east-1a"
pubsubnet2_cidr_block = "10.2.2.0/24"
pubsubnet2AZ          = "us-east-1b"

#privsubnet variables
privsubnet1_cidr_block = "10.2.3.0/24"
privsubnet1AZ          = "us-east-1a"
privsubnet2_cidr_block = "10.2.4.0/24"
privsubnet2AZ          = "us-east-1b"

#dbprivsubnet variables
dbprivsubnet1_cidr_block = "10.2.5.0/24"
dbprivsubnet1AZ          = "us-east-1a"
dbprivsubnet2_cidr_block = "10.2.6.0/24"
dbprivsubnet2AZ          = "us-east-1b"

#db variables
db_name  = "my_new_db"
username = "Admin"
password = "admin12345"
