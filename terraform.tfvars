availability_zone      = ["us-east-2a", "us-east-2b"]          # Replace with a valid Availability_zone
ami                    = "ami-0d1b5a8c13042c939" # Replace with a valid AMI ID
tags                   = "linux_machine"               # Specify your tag's
region                 = "us-east-2"      # Replace the region with your own Region
volume_size            = "10"                     # Specify the Volume Size
instance_type          = "t2.micro"               # Specify the instance type
key_name               = "private"            # specify your desired key
text1                  = "locals-example"
my_security_group      = "my-security-group" # Please specify your security group by changing your own security group name
my_vpc                 = "vpc-1"
cidr_block             = "10.0.0.0/16"
subnet_count           = "2"
//instance_count     = 2


