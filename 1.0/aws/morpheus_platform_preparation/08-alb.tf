# resource "aws_lb" "app_lb" {
#     name = "morph-ui-lb"
#     internal = false
#     load_balancer_type = "application"
#     security_groups = [aws_security_group.app_nodes.id]
#     subnets = aws_subnet.public_subnets.*.id


# }

# resource "aws_lb_listener" "https" {
#     load_balancer_arn = aws_lb.app_lb.arn
#     port = "443"
#     protocol = "HTTPS"
#     ssl_policy = "ELBSecurityPolicy-2016-08"

# }