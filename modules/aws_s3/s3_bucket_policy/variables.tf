variable "s3_bucket_id" {
  description = "Bucket Id"
  type        = string
}

variable "s3_bucket_arn" {
  description = "Bucket arn"
  type        = string
}

variable "s3_bucket" {
  description = "Bucket name"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "Cloudfront distribution arn"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "cloudfront_origin_access_identity_arn" {
  description = "OAI ARN"
  type        = string
}
