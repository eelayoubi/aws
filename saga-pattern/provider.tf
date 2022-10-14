terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "Terraform"
      Pattern     = "SAGA"
    }
  }
}