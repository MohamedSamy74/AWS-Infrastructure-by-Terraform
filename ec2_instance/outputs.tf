output "ec2_public_ips" {
    value = aws_instance.public_ec2[*].public_ip
  
}
output "ec2_private_ips" {
    value = aws_instance.private_ec2[*].private_ip
  
}

output "public_ec2_ids" {
    value = aws_instance.public_ec2[*].id
}

output "private_ec2_ids" {
    value = aws_instance.private_ec2[*].id
}
