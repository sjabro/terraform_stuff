locals {
  azs = ["${var.region}a"]
  az_map = {for a in local.azs: index(local.azs, a) => a}
}