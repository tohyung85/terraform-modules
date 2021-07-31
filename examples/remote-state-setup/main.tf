terraform {
  required_version = "~>1.0"

  required_providers {
    aws = {
      version = "~>3.0"
    }
  }
  # Partial configuration . The other settings (e.g bucket, region) will be
# passed in from a file via --backend-config arguments to 'terraform init'
  backend "s3" {
    key = "workspaces-example/terraform.tfstate"    
    # role_arn = "assumed_role"
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "terraformstate" {
  bucket = "tohyung-learning-terraform"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  # Enable versioning so we can see the fill revision history of our
  # state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "tohyung-learning-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.terraformstate.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}