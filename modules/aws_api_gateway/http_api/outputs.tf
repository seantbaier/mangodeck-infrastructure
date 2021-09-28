output "execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API. See the Amazon API Gateway Developer Guide for details."
  value       = aws_apigatewayv2_api.this[0].execution_arn
}

output "target_domain_name" {
  description = "(Computed) The target domain name."
  value       = aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].target_domain_name
}

output "domain_name_hosted_zone_id" {
  description = "(Computed) The Amazon Route 53 Hosted Zone ID of the endpoint."
  value       = aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].hosted_zone_id
}

output "custom_domain_name" {
  description = "(Required) The domain name. Must be between 1 and 512 characters in length."
  value       = aws_apigatewayv2_domain_name.this[0].domain_name

}
