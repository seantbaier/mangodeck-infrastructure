variable "create" {
  description = "Create resource conditionally."
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment the resource is provisioned in."
  type        = string
}

variable "app_name" {
  description = "Application/project name."
  type        = string
}

variable "tags" {
  description = "AWS resrouce tags."
  type        = map(any)
  default     = {}
}

variable "aws_s3_bucket_origin" {
  description = "AWS S3 bucket being used as the origin."
  type        = map(any)
}

variable "aliases" {
  description = " (Optional) - Extra CNAMEs (alternate domain names), if any, for this distribution."
  type        = list(any)
}

variable "acm_certificate_arn" {
  description = "The ARN of the AWS Certificate Manager certificate that you wish to use with this distribution. Specify this, cloudfront_default_certificate, or iam_certificate_id. The ACM certificate must be in US-EAST-1."
  type        = string
  default     = null
}
