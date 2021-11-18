###Provider/Region###
variable "region" {}

variable "access_key" {}

variable "secret_key" {}

###VPC Variables (vpc.tf)###
variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

####Security Groups (security-groups.tf)####
variable "wgm1_cidr" {
  type    = list(string)
  default = [ "10.0.0.0/8" ]
  description = "worker_group_mgmt_one cider block"
}

variable "wgm2_cidr" {
  type    = list(string)
  default = [
      "192.168.0.0/16"
    ]
  description = "worker_group_mgmt_two cider block"
}

variable "awm_cidr" {
  type    = list(string)
  default = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16"
    ]
  description = "all_worker_mgmt cider block"
}

####eks-cluster (eks-cluster.tf)####
