terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.35.0"
    }
  }
}

provider "aws" {

  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

  default_tags {
    
    tags = {
      Usage = "Morpheus Platform Infrastructure"
    }
  }
}

## TODO Test email change reapply