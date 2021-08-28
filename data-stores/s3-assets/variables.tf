variable "bucket_name" {
  type        = string
  description = "S3 Bucket Name"
}

variable "bucket_policy" {
  type        = string
  description = "AWS Bucket policy JSON. You can call file(filename) as input."
  default     = ""
}

variable "restrict_oai_access" {
  type        = bool
  description = "Secure access using CF OAI"
  default     = false
}

variable "cf_aliases" {
  type        = list(string)
  description = "List of domain aliases. e.g [\"mysite.example.com\", \"yoursite.example.com\"]"
  default     = []
}

variable "public_key" {
  type        = string
  description = "Public key for upload into cloudfront. You can call file(filename.pem) as input"
  default     = ""
}
