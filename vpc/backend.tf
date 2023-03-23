terraform {
  backend "s3" {
    bucket = "test-terraform-back"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}
