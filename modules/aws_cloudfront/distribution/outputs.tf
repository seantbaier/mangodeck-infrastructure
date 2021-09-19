output "domain_name" {
  description = "- The domain name corresponding to the distribution. For example: d604721fxaaqy9.cloudfront.net."
  value       = aws_cloudfront_distribution.this[0].domain_name
}

output "hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. This attribute is simply an alias for the zone ID Z2FDTNDATAQYW2."
  value       = aws_cloudfront_distribution.this[0].hosted_zone_id
}

output "arn" {
  description = "ARN of the distribution"
  value       = aws_cloudfront_distribution.this[0].arn
}

output "origin_access_identity_arn" {
  description = "Arn of OAI"
  value       = aws_cloudfront_origin_access_identity.this[0].iam_arn
}
