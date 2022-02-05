# main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  cloud {
    organization = "myorglocal"
    workspaces {
      name = "awswork1"
    }
  }
  required_version = ">= 1.1.0"
}

provider "aws" {
  profile = "default"
  access_key = "AKIAZ3MOZLM5KVL3N5JQ"
  secret_key = "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"
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0a8b4cd432b1c3063"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}

# variables.tf

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "Example2"
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}
