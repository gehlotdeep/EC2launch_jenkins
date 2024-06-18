
# Generate the key pair
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a AWS key pair
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}


# Create VPC's
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16" # CIDR block for your VPC
  enable_dns_hostnames = true          # Enable DNS hostnames for instances launched in this VPC

  tags = {
    Name = var.my_vpc # Specify a name for your VPC
  }
}


# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id # Attach the Internet Gateway to the VPC
}

# Create Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id # Reference the VPC created above
  cidr_block              = "10.0.1.0/24"     # CIDR block for your subnet
  map_public_ip_on_launch = true              # Automatically assign public IP addresses to instances in this subnet

  availability_zone = var.availability_zone # Specify the desired availability zone for your subnet

  tags = {
    Name = "PublicSubnet" # Specify a name for your subnet
  }
}


# Create Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id # Associate the route table with the VPC

  route {
    cidr_block = "0.0.0.0/0" # Route all traffic

    gateway_id = aws_internet_gateway.my_igw.id # Route traffic to the Internet Gateway
  }

  tags = {
    Name = "MyRouteTable" # Specify a name for your route table
  }
}


# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id       # Associate with the public subnet
  route_table_id = aws_route_table.my_route_table.id # Associate with the route table
}

# Create EC2 Instance
resource "aws_instance" "my_instance" {
  ami                    = var.ami           # Specify the AMI ID of the instance
  instance_type          = var.instance_type # Specify the instance type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  subnet_id              = aws_subnet.public_subnet.id # Specify the subnet to launch the instance in
  # ...
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
  
   # Introducing a 10-second pause
  provisioner "local-exec" {
    command = "sleep 10"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public_ips.txt"
  }
  tags = {
    Name = var.tags # Specify a name for your instance
  }
 

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = var.volume_size
    volume_type = "gp3"
  }



  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y openjdk-11-jdk
              wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add - 
              sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
              sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5BA31D57EF5975CA
              sudo apt-get update -y
              sudo apt-get install -y jenkins
              sudo systemctl start jenkins
              sudo systemctl enable jenkins
              EOF

}

# Null_resources 

resource "null_resource" "my_instance" {
  triggers = {
    id = aws_internet_gateway.my_igw.id
  }

  provisioner "local-exec" {
    command = "echo Hello World"
  }
}
resource "null_resource" "empty_bucket" {
  provisioner "local-exec" {
    command = <<EOT
      if aws s3 ls "s3://${aws_s3_bucket.example_bucket.bucket}" 2>&1 | grep -q 'NoSuchBucket'; then
        echo "Bucket does not exist or already empty";
      else
        echo "Emptying bucket...";
        aws s3 rm s3://${aws_s3_bucket.example_bucket.bucket} --recursive --exclude "*" --include "*";
      fi
    EOT
  }

  depends_on = [aws_s3_bucket.example_bucket]
}

# Create a bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "ayushjoshi"  # Change to your desired bucket name
}
resource "aws_s3_bucket_public_access_block" "example_bucket_public_access_block" {
  bucket = aws_s3_bucket.example_bucket.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

 
/*

 parent of f98b1f8... new commit
resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id
  name        = "my-security-group"
  description = "My security group created by Terraform"
  # Ingress rules (inbound traffic rules)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from anywhere (be cautious with this rule)
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP access from anywhere (be cautious with this rule)
  }

  # Egress rules (outbound traffic rules)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic (you can restrict this as needed)
    cidr_blocks = ["0.0.0.0/0"]
  }
}

*/
resource "aws_security_group" "my_security_group" {
  vpc_id      = aws_vpc.my_vpc.id
  name        = var.my_security_group
  description = "My security group created by Terraform"
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}



