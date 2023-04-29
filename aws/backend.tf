terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.59.0"
    }
  }
  backend "s3" {
    bucket = "test-tf-statefile-bucket"
    key = "test-terraform.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {
  shared_config_files = ["/root/.aws/config"] 
  shared_credentials_files = ["/root/.aws/credentials"] 
  profile = "default"
}

