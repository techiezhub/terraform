terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.59.0"
    }
  }
}
provider "aws" {
  shared_config_files = ["/root/.aws/config"] 
  shared_credentials_files = ["/root/.aws/credentials"] 
  profile = "default"
}
module "s3backend" {
  source = "../modules/s3backend"
  environment = var.environment
  service = var.service
}
