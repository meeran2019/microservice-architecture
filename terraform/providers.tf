Terraform {
  cloud {
	organization = “meeran-terraform-organization”
	workspaces {
  	name = “microservice-architecture”
	}
  }
  required_providers {
	aws = {
  	source  = “hashicorp/aws”
  	version = “>= 3.73.0”
	}
}

provider “aws” {
  region = "us-east-1"
}