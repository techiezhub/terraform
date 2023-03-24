resource "aws_instance" "nginx-server" {
  ami = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name = var.key_name
  subnet_id = aws_subnet.test-public.id 
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
  device_name = "/dev/sda"
  volume_id = "${aws_ebs_volume.data-vol.id}"
  instance_id = "${aws_instance.nginx-server.id}"
}
