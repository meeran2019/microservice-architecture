terraform {
  required_providers {
	aws = {
  	source  = "hashicorp/aws"
	}
    random = {
      source = "hashicorp/random"
    }
  }
}
provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::346464389794:role/ec2role"
  }
}


provider "random" {
  # Configuration options
}
