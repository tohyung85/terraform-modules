terraform {
  # Require Terraform at exactly version 0.12.0 
  required_version = "~> 1.0"

  required_providers {
    aws = {
      # Allow any 3.x version of the AWS provider 
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "asg" {
  source = "../../cluster/asg-rolling-deploy"

  cluster_name  = "example-asg"
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  min_size           = 1
  max_size           = 1
  enable_autoscaling = true

  subnet_ids = data.aws_subnet_ids.default.ids
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}
