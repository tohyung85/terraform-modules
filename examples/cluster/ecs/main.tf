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

module "ecs" {
  source             = "../../../cluster/ecs"
  name               = "test-api"
  instance_type      = "t2.micro"
  subnets            = data.aws_subnet_ids.default.ids
  asg_desired        = 1
  asg_max            = 2
  asg_min            = 0
  container_insights = false
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}
