resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = var.route_table[0]
    gateway_id = var.igw_id
  }
  route {
    ipv6_cidr_block = var.route_table[1]
    gateway_id = var.igw_id
  }
}
# Associate public subnet with the public route table
resource "aws_route_table_association" "public_subnet_association" {
  count = 2
  subnet_id      = var.subnet_id[count.index]
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = var.route_table[0]
    gateway_id = var.nat_id
  }
}
# Associate private subnet with the private route table
resource "aws_route_table_association" "private_subnet_association" {
  count = 2
  subnet_id      = var.subnet_id[count.index + 2]
  route_table_id = aws_route_table.private_route_table.id
}
