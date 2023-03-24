resource "aws_s3_bucket" "s3-backend" {
  bucket = "${var.environment}-${var.service}tf-state-buck"
}
resource "aws_s3_bucket_public_access_block" "s3-backend-acl" {
  bucket = aws_s3_bucket.s3-backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}