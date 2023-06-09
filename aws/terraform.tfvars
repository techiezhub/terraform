# cidr_block = "10.0.0.0/16"
# public_subnets_cidr = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24","10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
# availability_zones = [""]
# private_subnets_cidr = ["10.0.101.0/24","10.0.102.0/24","10.0.103.0/24","10.0.104.0/24","10.0.105.0/24","10.0.106.0/24"]
region = "us-east-1"
environment = "test"
service = "vpc"
ami = "ami-0557a15b87f6559cf"
instance_type = "t2.micro"
associate_public_ip_address = "true"
key_name = "test-key-pair"
size = 30
root_block_device = ["true",15,"gp3"]
vpc_security_group_ids =["sg-01be1aa3d801d54a5"]
#  ["module.vpc.aws_security_group.allow-all"]
# test-public-subnet = ""
# test-public-subnet = "subnet-0f713cdb8a1d22474" 