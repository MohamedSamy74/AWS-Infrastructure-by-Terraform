module "my-vpc" {
  source   = "./VPC-igw"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "my-vpc"
}
module "my-subnet" {
  source            = "./subnet"
  vpc_id            = module.my-vpc.vpc_id
  subnet_cidr       = ["10.0.0.0/24", "10.0.2.0/24", "10.0.1.0/24", "10.0.3.0/24"]
  subnet_name       = ["public-subnet-1", "public-subnet-2", "private-subnet-1", "private-subnet-2"]
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}

module "nat_gw" {
  source = "./NAT"
#   vpc_id = module.my-vpc.vpc_id
  subnet_id = module.my-subnet.subnet_id

}
module "route_table" {
  source = "./route-table"
  vpc_id = module.my-vpc.vpc_id
  route_table = [ "0.0.0.0/0" , "::/0" ]
  igw_id = module.my-vpc.igw_id
  subnet_id = module.my-subnet.subnet_id
  nat_id = module.nat_gw.nat_id
}

module "security_group" {
    source = "./security_group"
    vpc_id = module.my-vpc.vpc_id
    sg_name = "my-sg"
    ingress = {
        HTTP = {
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"] }
        SSH = {
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"] }
    }
    egress = {
        all = {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"] }
    }
}

module "servers" {
    source = "./ec2_instance"
    # vpc_id = module.my-vpc.vpc_id
    security_group_id = module.security_group.security_group_id
    instance_type = "t2.micro"
    subnet_id = module.my-subnet.subnet_id
    ssh_key_name = "new-key"
    private_lb_dns = module.load_balancers.private_lb_dns
}

module "load_balancers" {
    source = "./load_balancer"
    subnet_id = module.my-subnet.subnet_id
    security_group_id = module.security_group.security_group_id
    vpc_id = module.my-vpc.vpc_id
    public_ec2_ids = module.servers.public_ec2_ids
    private_ec2_ids = module.servers.private_ec2_ids
}

