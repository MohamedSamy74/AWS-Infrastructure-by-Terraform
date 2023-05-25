resource "aws_eip" "my_eip" {
  vpc      = true
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = var.subnet_id[0]
}
