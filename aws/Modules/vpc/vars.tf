# variable "cidr_block" {}
# variable "public_subnets_cidr" {}
# variable "availability_zones" {}
# variable "private_subnets_cidr" {}
# variable "region" {}
# variable "environment" {}
# variable "service" {}
variable "cidr_block" {
  default = "10.0.0.0/16"
}
variable "public_subnets_cidr" {
  default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24","10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
}
variable "private_subnets_cidr" {
  default = ["10.0.101.0/24","10.0.102.0/24","10.0.103.0/24","10.0.104.0/24","10.0.105.0/24","10.0.106.0/24"]
}
variable "region" {
  default = "us-east-1"
}
variable "environment" {
  default = "test"
}
variable "service" {
  default = "vpc"
}

# variable "test-vpc" {}
# variable "test-public-subnet" {}
# variable "ami" {}
# variable "instance_type" {}
# variable "associate_public_ip_address" {}
# variable "key_name" {}
# variable "size" {}
# variable "root_block_device" {}
# variable "vpc_security_group_ids" {}
# variable "test-public-subnet" {}