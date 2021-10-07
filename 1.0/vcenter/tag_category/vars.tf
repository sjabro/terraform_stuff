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