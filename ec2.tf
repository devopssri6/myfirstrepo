provider "aws" {
  region = "ap-south-1" # Change if needed
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "awskey"
  #public_key = file("~/.ssh/id_rsa.pub") # Ensure this file exists
}

resource "aws_security_group" "ec2_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all (you can restrict this)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ec2_key.key_namea
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "MyEC2Instance"
  }
}
