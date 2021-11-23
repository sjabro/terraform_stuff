# ## TODO Figure out SSL cert

resource "aws_lb_target_group" "morph_apps" {
    name = "morpheus-app-nodes-tg"
    port = 443
    protocol = "TCP"
    vpc_id = aws_vpc.main.id

    health_check {
        port = 443
        protocol = "HTTPS"
    }
}

resource "aws_lb_target_group_attachment" "morph_apps" {
    for_each = local.az_map
    target_group_arn = aws_lb_target_group.morph_apps.arn
    target_id = aws_instance.app_node[each.key].id
    port = 443
}

resource "aws_lb" "lb" {
    name = "morph-ui-lb"
    internal = false
    load_balancer_type = "network"
    subnets = [aws_subnet.public_subnets[0].id,aws_subnet.public_subnets[1].id,aws_subnet.public_subnets[2].id]
}

resource "aws_lb_listener" "https" {
    load_balancer_arn = aws_lb.lb.arn
    port = "443"
    protocol = "TCP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.morph_apps.arn
    }
}