terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "1.25.0"
    }
  }
}

provider "vsphere" {
    user = var.user
    password = var.password
    vsphere_server = var.vsphere_server

    allow_unverified_ssl = true
}