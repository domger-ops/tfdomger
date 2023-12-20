provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "instance01" {
  ami           = "ami-0082110c417e4726e"  # Use the AMI ID for your desired image
  instance_type = "t2.micro"  # Choose an appropriate instance type

  tags = {
    Name = "instance01"
  }
}

