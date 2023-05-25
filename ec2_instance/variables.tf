variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "subnet_id" {
  
}

variable "security_group_id" {
  
}
variable "ssh_key_name" {
    type = string
    default = "new-key"
}

variable "private_lb_dns" {
  
}
