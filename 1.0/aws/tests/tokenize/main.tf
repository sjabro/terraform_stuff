terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.35.0"
    }
  }
}

provider "aws" {
}

locals {
  output_1 = "<%=customOptions.fargateTokenize.tokenize('|')[0]%>"
}

output "output_1" {
  value = local.output_1
}