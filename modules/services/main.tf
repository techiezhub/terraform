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
resource "aws_s3_bucket" "s3-backend" {
  bucket = "${var.environment}-tf-statefile-bucket"
}
resource "aws_s3_bucket_public_access_block" "s3-backend-acl" {
  bucket = aws_s3_bucket.s3-backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_instance" "nginx-server" {
  ami = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name = var.key_name
  subnet_id = aws_subnet.test-public-subnet.0.id 
  tags = {
    "Name" = "nginx-server"
  }
}
resource "aws_ebs_volume" "data-vol" {
  availability_zone = "us-east-1a"
  size = var.size
  tags = {
    Name = "Data-Volume"
  }
}
resource "aws_volume_attachment" "data-vol-attach" {
  device_name = "/dev/sdh"
  volume_id = "${aws_ebs_volume.data-vol.id}"
  instance_id = "${aws_instance.nginx-server.id}"
}






















