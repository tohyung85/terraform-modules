locals {
  bucket_name        = var.bucket_name
  policy_json        = var.bucket_policy
  public_key         = var.public_key
  create_oai         = var.restrict_oai_access ? true : false
  cf_aliases         = var.cf_aliases
  create_trust_group = var.public_key == "" ? false : true
}

# Enable later once connection can be established!
resource "aws_s3_bucket_public_access_block" "assets_bucket" {
  depends_on = [aws_s3_bucket_policy.assets_bucket]
  bucket     = aws_s3_bucket.assets_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket" "assets_bucket" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_policy" "assets_bucket" {
  bucket = aws_s3_bucket.assets_bucket.id

  policy = data.aws_iam_policy_document.combined.json
}

data "aws_iam_policy_document" "combined" {
  source_json = local.policy_json == "" ? "" : local.policy_json

  # Add another policy
  dynamic "statement" {
    for_each = local.create_oai ? [1] : []
    content {
      sid = "CloudfrontPrivateReadAccess"
      principals {
        type        = "AWS"
        identifiers = [aws_cloudfront_origin_access_identity.cf_oai[0].iam_arn]
      }
      actions   = ["s3:GetObject"]
      resources = ["${aws_s3_bucket.assets_bucket.arn}/*"]
    }
  }

}

# Cloudfront

data "aws_cloudfront_cache_policy" "this" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "this" {
  name = "Managed-CORS-S3Origin"
}

resource "aws_cloudfront_public_key" "cf_trust_group_public_key" {
  count       = local.create_trust_group ? 1 : 0
  comment     = "Public key created in cloudfront"
  encoded_key = local.public_key
  name        = "${local.bucket_name}_s3_cf_public_key"
}

resource "aws_cloudfront_key_group" "cf_key_group" {
  count = local.create_trust_group ? 1 : 0
  items = [aws_cloudfront_public_key.cf_trust_group_public_key[0].id]
  name  = "${local.bucket_name}-group"
}

resource "aws_cloudfront_origin_access_identity" "cf_oai" {
  count   = local.create_oai ? 1 : 0
  comment = "OAI for cloudfront access to S3"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.assets_bucket.bucket_domain_name
    origin_id   = local.bucket_name

    dynamic "s3_origin_config" {
      for_each = local.create_oai ? [1] : []
      content {
        origin_access_identity = aws_cloudfront_origin_access_identity.cf_oai[0].cloudfront_access_identity_path
      }
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "Cloudfront for S3 Bucket ${local.bucket_name}"
  # default_root_object = "index.html"

  # logging_config {
  #   include_cookies = false
  #   bucket          = "mylogs.s3.amazonaws.com"
  #   prefix          = "myprefix"
  # }

  aliases = local.cf_aliases

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.bucket_name
    compress         = true

    trusted_key_groups = local.create_trust_group ? [aws_cloudfront_key_group.cf_key_group[0].id] : []

    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.this.id
    cache_policy_id          = data.aws_cloudfront_cache_policy.this.id
    viewer_protocol_policy   = "redirect-to-https"
    min_ttl                  = 0
    default_ttl              = 3600
    max_ttl                  = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      # locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "test"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
