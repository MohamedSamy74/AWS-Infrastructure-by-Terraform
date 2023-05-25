resource "aws_security_group" "security_group" {
  name        = var.sg_name
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.ingress.HTTP.from_port
    to_port     = var.ingress.HTTP.to_port
    protocol    = var.ingress.HTTP.protocol
    cidr_blocks = var.ingress.HTTP.cidr_blocks
  }
  ingress {
    from_port   = var.ingress.SSH.from_port
    to_port     = var.ingress.SSH.to_port
    protocol    = var.ingress.SSH.protocol
    cidr_blocks = var.ingress.SSH.cidr_blocks
  }

  egress {
    from_port   = var.egress.all.from_port
    to_port     = var.egress.all.to_port
    protocol    = var.egress.all.protocol
    cidr_blocks = var.egress.all.cidr_blocks
  }
}