data "aws_availability_zones" "available" {}
resource "aws_vpc" "test-vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
    tags = {
        Name = "${var.environment}-vpc"
    }
}
resource "aws_subnet" "test-public-subnet" {
  # These three commented lines for automatically create subnets as per Az's available in current region
  # count = length(data.aws_availability_zones.available.names)
  # cidr_block = "10.0.${100 + count.index}.0/24"
  # availability_zone       = element(var.availability_zones, count.index)
  vpc_id                  = aws_vpc.test-vpc.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.environment}-${data.aws_availability_zones.available.names[count.index]}-public-subnet"
  }
}
resource "aws_subnet" "test-private-subnet" {
  # These three commented lines for automatically create subnets as per Az's available in current region
  # availability_zone       = element(var.availability_zones, count.index)
  # count = length(data.aws_availability_zones.available.names)
  # cidr_block = "10.0.${200 + count.index}.0/24"
  vpc_id                  = aws_vpc.test-vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    "Name" = "${var.environment}-${data.aws_availability_zones.available.names[count.index]}-private-subnet"
  }
}
resource "aws_internet_gateway" "test-internet-gateway" {
  vpc_id = aws_vpc.test-vpc.id
  tags = {
    "Name" = "${var.environment}-internet-gateway"
  }
}
resource "aws_route_table" "test-route-table-pub" {
  vpc_id = aws_vpc.test-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-internet-gateway.id
  }
  tags = {
    "Name" = "${var.environment}-route-table-pub"
  }
}
resource "aws_route_table_association" "test-route-asso-pub" {
  count = length(data.aws_availability_zones.available.names)
  subnet_id = element(aws_subnet.test-public-subnet.*.id, count.index)
  route_table_id = aws_route_table.test-route-table-pub.id
}
# resource "aws_eip" "nat-public-ip"{
#     vpc = true
# } 
# resource "aws_nat_gateway" "test-nat-gateway" {
#   allocation_id = aws_eip.nat-public-ip.id
#   subnet_id = element(aws_subnet.test-private-subnet.*.id, 1)
#   depends_on = [
#     aws_internet_gateway.test-internet-gateway
#   ]
# }
# resource "aws_route_table" "test-route-table-pri" {
#   vpc_id = aws_vpc.test-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.test-nat-gateway.id
#   }
#   tags = {
#     "Name" = "${var.environment}-route-table-pri"
#   }
# }
# resource "aws_route_table_association" "test-route-asso-pri" {
#   count = length(data.aws_availability_zones.available.names)
#   subnet_id = element(aws_subnet.test-private-subnet.*.id, count.index)
#   route_table_id = aws_route_table.test-route-table-pri.id
# }
resource "aws_security_group" "allow-all" {
  name = "allow-all"
  vpc_id = aws_vpc.test-vpc.id
  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-all"
  }
}
# resource "aws_instance" "nginx-server" {
#   ami = var.ami
#   instance_type = var.instance_type
#   associate_public_ip_address = var.associate_public_ip_address
#   key_name = var.key_name
#   subnet_id = aws_subnet.test-public-subnet.0.id 
#   security_groups = [aws_security_group.allow-all.id]
#   root_block_device {
#     delete_on_termination = true
#     volume_size = 15
#     volume_type = "gp3"
#     }  
#   user_data = <<EOF
#   #!/bin/bash
#   apt-get update
#   apt-get install nginx -y
#   service nginx start
#   EOF
#   tags = {
#     "Name" = "nginx-server"
#   }
# }
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



















