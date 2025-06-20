terraform {
  backend "s3" {
    bucket = "my-terraform-tfstate-cloudsaga"
    key = "vpc/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }

  required_providers {
    aws = {
        version = "~> 5.0"
        source = "hashicorp/aws"
    }
  }
}