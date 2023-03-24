data "aws_availability_zones" "available" {}
module "services" {
  source = "../modules/services"
  region = var.region
  environment = var.environment
  service = var.service
  cidr_block = var.cidr_block
  public_subnets_cidr = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones = data.aws_availability_zones.available.names
  ami = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name = var.key_name
  size = var.size
}





















