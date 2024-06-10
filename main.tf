terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "minecraft_security_group" {
  name        = "minecraft_security_group"
  description = "Security group for Minecraft server"
  vpc_id      = "vpc-039c90984b3c9dba5"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Minecraft"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "minecraft_key_pair" {
  key_name   = "minecraft_key_pair"
  public_key = file("~/.ssh/minecraft_rsa.pub")
}

resource "aws_instance" "minecraft-server" {
  ami           = "ami-0cf2b4e024cdb6960"
  instance_type = "t2.small"
  key_name      = aws_key_pair.minecraft_key_pair.key_name

  security_groups = [aws_security_group.minecraft_security_group.name]

  tags = {
    Name = "Minecraft Server"
  }
}
