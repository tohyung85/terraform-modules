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

module "postgres" {
  source = "../../../data-stores/rds"

  db_instance_prefix   = "example"
  db_instance_type     = "db.t2.micro"
  db_name              = "test_db"
  db_allocated_storage = 10
  db_password          = "changeMe"
  engine_version       = "10.14"
  db_engine            = "postgres"

  publicly_accessible = true
  subnet_ids = [
    "subnet-0256a0fc0fd7eab9a",
    "subnet-0d1a153524516751c"
  ]
}
