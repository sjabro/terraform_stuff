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
        App_Name = "<%=customOptions.fargateTokenize.tokenize('|')[0]%>"
        Business_Group = "<%=customOptions.fargateTokenize.tokenize('|')[1]%>"
        Cost_Code = "<%=customOptions.fargateTokenize.tokenize('|')[2]%>"
        Business_Owner = "<%=customOptions.fargateTokenize.tokenize('|')[3]%>"
        App_Code = "<%=customOptions.fargateTokenize.tokenize('|')[4]%>"
        App_Owner = "<%=customOptions.fargateTokenize.tokenize('|')[5]%>"
}

output "app_name" {
  value = local.App_Name
}

output "business_group" {
  value = local.Business_Group
}

output "cost_code" {
  value = local.Cost_Code
}

output "business_owner" {
  value = local.Business_Group
}

output "app_code" {
  value = local.App_Code
}

output "app_owner" {
  value = local.App_Owner
}