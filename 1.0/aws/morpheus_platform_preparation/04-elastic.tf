############################################################
# ELASTICSEARCH/OPENSEARCH
############################################################
# resource "aws_iam_service_linked_role" "es" {
#   aws_service_name = "es.amazonaws.com"
# }

# resource "aws_elasticsearch_domain" "main" {
#   domain_name = "morpheus"
#   elasticsearch_version = "7.10"

#   cluster_config {
#     instance_type = "m3.large.elasticsearch"
#   }

#   vpc_options {
#     subnet_ids = [
#       aws_subnet.private_subnets[0].id
#     ]
#   }

#   tags = {
#     "Name" = "Morph Search"
#   }
# }