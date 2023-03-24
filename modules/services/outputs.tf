output "vpc" {
  value = aws_vpc.test-vpc.id
}
output "test-public-subnet" {
  value = ["${aws_subnet.test-public-subnet.*.id}"]
}
output "test-private-subnet" {
  value = ["${aws_subnet.test-private-subnet.*.id}"]
}
output "test-route-table-pub" {
  value = aws_route_table.test-route-table-pub.id
}
output "s3_bucket_name" {
  value = aws_s3_bucket.s3-backend.id
}
output "nginx-server" {
  value = aws_instance.nginx-server.id
}