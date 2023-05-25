output "public_lb_dns" {
    value = aws_lb.load_balancers[0].dns_name
}

output "private_lb_dns" {
    value = aws_lb.load_balancers[1].dns_name
}