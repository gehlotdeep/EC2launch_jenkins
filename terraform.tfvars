availability_zone = "eu-north-1a"           # Replace with a valid Availability_zone
ami               = "ami-0705384c0b33c194c" # Replace with a valid AMI ID
tags              = "linux-server"               # Specify your tag's
region            = "eu-north-1"      # Replace the region with your own Region
volume_size       = "8"                     # Specify the Volume Size
instance_type     = "t2.micro"               # Specify the instance type
key_name          = "private-key"            # specify your desired key
text1             = "locals-example"
my_security_group = "my-new-sg" # Please specify your security group by changing your own security group name
my_vpc            = "vpc-1"
<<<<<<< HEAD
AWS_ACCESS_KEY_ID     = ""
AWS_SECRET_ACCESS_KEY = ""
//instance_count     = 2
