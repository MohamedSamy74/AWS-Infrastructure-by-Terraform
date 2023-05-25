data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]
#   owners = ["amazon"]

  filter {
    name   = "name"
    # values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-*-server-*"]
    # values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "public_ec2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  associate_public_ip_address = true
  count = 2
  subnet_id = var.subnet_id[count.index]
  vpc_security_group_ids = [var.security_group_id]
  key_name = var.ssh_key_name
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      "sudo unlink /etc/nginx/sites-enabled/default",
      "sudo sh -c 'echo \"server { \n listen 80; \n location / { \n proxy_pass http://${var.private_lb_dns}; \n } \n }\" > /etc/nginx/sites-available/reverse-proxy.conf'",
      "sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf",
      "sudo systemctl restart nginx"
    ]    
   connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./new-key.pem")
      host        = self.public_ip
      timeout = "4m"
    }
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ./all-ips.txt"
  }
}

resource "aws_instance" "private_ec2" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    associate_public_ip_address = false
    count = 2
    subnet_id = var.subnet_id[count.index + 2]
    vpc_security_group_ids = [var.security_group_id]
    key_name = var.ssh_key_name
    user_data = <<-EOF
        apt update
        apt install apache2 -y
        systemctl start apache2
        systemctl enable apache2
      EOF   
    provisioner "local-exec" {
    command = "echo ${self.private_ip} >> ./all-ips.txt"
  }
}