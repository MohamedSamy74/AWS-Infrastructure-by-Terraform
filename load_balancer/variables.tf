variable "lb-name" {
  type = list(string)
  default = ["Public-lb", "Private-lb"]
}

variable "subnet_id" {
    type = list
}

variable "security_group_id" {
  
}

variable "tg_name" {
    type = list
    default = ["Public-tg", "Private-tg"]
}

variable "vpc_id" {
  
}

variable "public_ec2_ids" {
  type = list
}

variable "private_ec2_ids" {
  type = list
}

