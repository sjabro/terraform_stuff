variable "category_name" {
    type = string
    default = "tf-test-category"
}

variable "category_types" {
    type = list(string)

    default = [
         "VirtualMachine",
         "Datastore" 
        ]
}

variable "category_cardinality" {
    type = string
    default = "SINGLE"

}

variable "category_description" {
    type = string
    default = "Managed by Terraform"
  
}

resource "vsphere_tag_category" "category" {
  name        = var.category_name
  description = var.category_description
  cardinality = var.category_cardinality

  associable_types = var.category_types
}

output "tag_category" {
  value = vsphere_tag_category.category
}