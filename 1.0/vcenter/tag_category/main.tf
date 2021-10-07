resource "vsphere_tag_category" "category" {
  name        = var.category_name
  description = var.category_description
  cardinality = var.category_cardinality

  associable_types = var.category_types
}