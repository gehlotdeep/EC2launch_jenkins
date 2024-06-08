output "jenkins_url" {
  value = "http://${aws_instance.my_instance.public_ip}:8080"
}


output "ec2_key" {
  value = aws_instance.my_instance.key_name
}

output "vpc_id" {
  value = aws_internet_gateway.my_igw.vpc_id
}

output "subnet_id" {
  value = aws_route_table_association.public_subnet_association.subnet_id
}

output "ami" {
  value = aws_instance.my_instance.ami

}

output "instance_id" {
  value = aws_instance.my_instance
}

output "public_ip" {
  value = aws_instance.my_instance.public_ip
}

output "private_key_pem" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}
