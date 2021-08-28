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
  assume_role {
    role_arn = "arn:aws:iam::725110312609:role/OrganizationAccountAccessRole"
  }
}

module "s3-assets" {
  source              = "../../../data-stores/s3-assets"
  bucket_name         = "my-s3-assets-bucket-test"
  bucket_policy       = file("policy.json")
  restrict_oai_access = true
  public_key          = file("public_key.pem")
}

output "bucket_arn" {
  value       = module.s3-assets.s3_arn
  description = "S3 ARN"
}
# {
#   "Sid": "CloudfrontPrivateContent",
#   "Effect": "Allow",
#   "Principal": {
#     "AWS": "AIDAIUJMTSAYIF3DHT654"
#   },
#   "Action": "s3:GetObject",
#   "Resource": "arn:aws:s3:::tuesdayten-assets/*"
# }
output "distribution_domain_name" {
  value       = module.s3-assets.cloudfront_domain_name
  description = "Cloudfront domain name"
}

output "oai_arn" {
  value       = module.s3-assets.cloudfront_oai_arn
  description = "Created Cloudfront OAI ARN"
}

output "cloudfront_public_key_id" {
  value       = module.s3-assets.cloudfront_public_key_id
  description = "Cloudfront public key id"
}
