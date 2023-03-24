module "ec2" {
  source = "../modules/ec2"
  ami = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name = var.key_name
  size = var.size
}



