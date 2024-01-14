terraform {
  cloud {
	organization = "meeran-terraform-organization"
	workspaces {
  	name = "microservice-architecture"
	}
  }

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
}


provider "random" {
  # Configuration options
}
