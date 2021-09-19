output "arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.this[0].arn
}

output "bucket" {
  description = "Name of the bucket"
  value       = aws_s3_bucket.this[0].bucket
}

output "id" {
  description = "AWS S3 bucket id."
  value       = aws_s3_bucket.this[0].id
}

output "bucket_regional_domain_name" {
  description = "AWS S3 bucket regional domain name."
  value       = aws_s3_bucket.this[0].bucket_regional_domain_name
}

output "website_endpoint" {
  description = "AWS S3 bucket website endpoint."
  value       = aws_s3_bucket.this[0].website_endpoint
}
