module "vpc" {
  source = "../vpc"
}
resource "aws_instance" "nginx-server" {
  ami = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name = var.key_name
  subnet_id = module.vpc.test-public-subnet.4.id
  vpc_security_group_ids = module.vpc.vpc_security_group_ids
  root_block_device {
    delete_on_termination = true
    volume_size = 15
    volume_type = "gp3"
    }  
  user_data = <<EOF
  #!/bin/bash
  apt-get update
  apt-get install nginx -y
  service nginx start
  EOF
  tags = {
    "Name" = "nginx-server"
  }
}
# resource "aws_ebs_volume" "data-vol" {
#   availability_zone = "us-east-1a"
#   size = var.size
#   tags = {
#     Name = "Data-Volume"
#   }
# }
# resource "aws_volume_attachment" "data-vol-attach" {
#   device_name = "/dev/sdh"
#   volume_id = "${aws_ebs_volume.data-vol.id}"
#   instance_id = "${aws_instance.nginx-server.id}"
# }
# resource "aws_ami_from_instance" "nginx-server-ami" {
#   name = "nginx-server-ami" 
#   source_instance_id = aws_instance.nginx-server.id
#   snapshot_without_reboot = false
# }

# resource "aws_iam_role" "test-eks-role" {
#   name = "test-eks-role"
#   assume_role_policy = <<POLICY
#   {
#     "Version" : "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Principal": {
#           "Service": "eks.amazonaws.com"
#         },
#         "Action": "sts:AssumeRole"
#       }
#     ]
#   }
#   POLICY
# }

# resource "aws_iam_role_policy_attachment" "test-eks-AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role = "${aws_iam_role.test-eks-role.name}"
# }

# resource "aws_iam_role_policy_attachment" "test-eks-AmazonEKSServicePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
#   role = "${aws_iam_role.test-eks-role.name}"
# }

# resource "aws_eks_cluster" "test-eks-cluster" {
#   name = "test-eks-cluster"
#   role_arn = "${aws_iam_role.test-eks-role.arn}"
#   version = "1.25"
#   enabled_cluster_log_types = [ "api","audit","authenticator","controllerManager","scheduler" ]
#   vpc_config {
#     security_group_ids = [ "${aws_security_group.allow-all.id}" ]
#     subnet_ids = [ "${aws_subnet.test-public-subnet.0.id}" ,"${aws_subnet.test-public-subnet.1.id}" ]
#   }
#   depends_on = [
#     aws_iam_role_policy_attachment.test-eks-AmazonEKSClusterPolicy,
#     aws_iam_role_policy_attachment.test-eks-AmazonEKSServicePolicy
#   ]
# }



















