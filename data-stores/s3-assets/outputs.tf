output "s3_id" {
  value       = aws_s3_bucket.assets_bucket.id
  description = "S3 Bucket ID"
}

output "s3_arn" {
  value       = aws_s3_bucket.assets_bucket.arn
  description = "S3 Bucket ARN"
}

output "s3_domain" {
  value       = aws_s3_bucket.assets_bucket.bucket_regional_domain_name
  description = "S3 domain name"
}

output "cloudfront_oai_arn" {
  value       = local.create_oai ? aws_cloudfront_origin_access_identity.cf_oai[0].iam_arn : null
  description = "Created OAI Arn"
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "Domain Name"
}

output "cloudfront_public_key_id" {
  value       = local.create_trust_group ? aws_cloudfront_public_key.cf_trust_group_public_key[0].id : null
  description = "Cloudfront Public key id"
}
