terraform {
  required_version = "~>1.0"

  required_providers {
    aws = {
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../../networking/vpc"

  name = "example_vpc"

  azs = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
  ]

  tiers = [
    { name : "web", public : true },
    { name : "app", public : false },
    { name : "db", public : false },
    { name : "reserved", public : false },
  ]

  // Optional
  reserved_azs = 1
  vpc_cidr     = "10.16.0.0/16"
  assign_ipv6  = true
}

output "ipv6_cidr_block" {
  description = "IPv6 CIDR"
  value       = module.vpc.ipv6_cidr_block
}

output "created_vpc_id" {
  value       = module.vpc.created_vpc_id
  description = "Created subnets"
}

output "created_subnet_ids" {
  value       = module.vpc.created_subnet_ids
  description = "Created subnets"
}
