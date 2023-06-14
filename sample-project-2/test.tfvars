# Below variables are used for Provider

provider_region="us-west-2"

provider_profile="default"

# Below variables are used for VPC

vpc_cidr_block= "192.168.0.0/16"

vpc_name_tag="imm-b-m-w-vpc"

# Below variables are used for web Public Subnets

web_public_subnet_1_cidr="192.168.1.0/24"

web_public_subnet_1_az="us-west-2a"

web_public_subnet_2_cidr="192.168.2.0/24"

web_public_subnet_2_az="us-west-2b"

# Below variables are used for App Private Subnets

app_private_subnet_1_cidr="192.168.3.0/24"

app_private_subnet_1_az="us-west-2a"

app_private_subnet_2_cidr="192.168.4.0/24"

app_private_subnet_2_az="us-west-2b"

# Below variables are used for DB Private Subnets

db_private_subnet_1_cidr="192.168.5.0/24"

db_private_subnet_1_az="us-west-2a"

db_private_subnet_2_cidr="192.168.6.0/24"

db_private_subnet_2_az="us-west-2b"

# Below variables are used for Public EC2

noofec2 = 2

public_instance_type="t2.micro"

public_ec2_name_tag= "imm-b-m-w-public-ec2"

# Below variables are used for Private EC2

private_instance_type="t2.micro"

private_ec2_name_tag="imm-b-m-w-private-ec2"

#  Below variables are used for RDS

subnet_group_name="immbmwsg"

db_name="imm-b-m-w-db"

instance_class= "db.t2.micro"

username="admin"

password="admin123"
