resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
}