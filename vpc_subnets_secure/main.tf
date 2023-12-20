provider "aws" {
  region = "us-west-1"  # Change to your preferred region
}

resource "aws_vpc" "my_vpc" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-1a"  # Change to your preferred AZ
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-1c"  # Change to your preferred AZ
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.domger_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "domgerops_home_security_group" {
  vpc_id      = aws_vpc.my_vpc.id  # Associate the security group with the VPC
  name        = "domgerops home ssh"
  description = "ssh from home pc and vbox"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "47.157.252.121/32",  # Replace with your PC's IP address
      "47.157.252.121/32",     # Replace with your VBox's IP address
    ]
  }

  # Add more ingress/egress rules as needed
}

resource "aws_instance" "domgerpubinstance" {
  ami                    = "ami-0082110c417e4726e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id  # Update with your subnet ID
  vpc_security_group_ids = [aws_security_group.domgerops_home_security_group.id]
  key_name               = "domgerops_tf_ssh"
 
  tags = {
    Name = "domgerpubinstance"
  }
}

resource "aws_internet_gateway" "domger_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "domger-igw"
  }
}

