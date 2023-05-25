resource "aws_subnet" "my_subnet" {
  vpc_id     = var.vpc_id
  count = length(var.subnet_cidr)
  cidr_block = var.subnet_cidr[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    Name = var.subnet_name[count.index]
  }
}