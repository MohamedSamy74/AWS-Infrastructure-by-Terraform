resource "aws_lb" "load_balancers" {
    count              = 2
    name               = var.lb-name[count.index]
    internal           = count.index == 0 ? false : true
    load_balancer_type = "application"
    subnets            = count.index == 0 ? [var.subnet_id[count.index], var.subnet_id[count.index+1]] : [var.subnet_id[count.index+1], var.subnet_id[count.index+2]]
    security_groups    = [var.security_group_id]
}

resource "aws_lb_target_group" "target_groups" {
    count       = 2
    name        = var.tg_name[count.index]
    port        = 80
    protocol    = "HTTP"
    vpc_id      = var.vpc_id
    target_type = "instance"
}

resource "aws_lb_listener" "listeners" {
    count = 2
    load_balancer_arn = aws_lb.load_balancers[count.index].arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.target_groups[count.index].arn
    }
}

resource "aws_lb_target_group_attachment" "public_tg_attachment" {
    count = 2
    target_group_arn = aws_lb_target_group.target_groups[0].arn
    target_id        = var.public_ec2_ids[count.index]
    port             = 80
}

resource "aws_lb_target_group_attachment" "private_tg_attachment" {
    count = 2
    target_group_arn = aws_lb_target_group.target_groups[1].arn
    target_id        = var.private_ec2_ids[count.index]
    port             = 80
}
