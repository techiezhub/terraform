# resource "aws_instance" "test-ec2" {
#   ami = ami-0557a15b87f6559cf
#   instance_type = t2.micro
#   associate_public_ip_address = true
#   key_name = test-key-pair
#   subnet_id = aws_subnet.test-public-subnet.id
#   # ebs_block_device =
# }