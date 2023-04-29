data "aws_availability_zones" "available" {}
module "vpc" {
  source = "./Modules/vpc"
  # region = var.region
  # environment = var.environment
  # service = var.service
  # cidr_block = var.cidr_block
  # public_subnets_cidr = var.public_subnets_cidr
  # private_subnets_cidr = var.private_subnets_cidr
  # availability_zones = data.aws_availability_zones.available.names
  # vpc_security_group_ids = var.vpc_security_group_ids
  # test-public-subnet = var.test-public-subnet
}
module "ec2" {
  source = "./Modules/ec2"
  environment = var.environment
  service = var.service
  # subnet_id = module.vpc.test-public-subnet
  vpc_security_group_ids = var.vpc_security_group_ids
  # test-public-subnet = var.test-public-subnet
  ami = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name = var.key_name
  size = var.size
  root_block_device = var.root_block_device
  depends_on = [
    module.vpc
  ]
}




















