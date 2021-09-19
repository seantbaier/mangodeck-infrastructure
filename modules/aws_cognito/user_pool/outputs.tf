output "id" {
  description = "AWS Cognito user pool id"
  value       = aws_cognito_user_pool.this.id
}

output "user_pool_client_id" {
  description = "AWS Cognito user pool client id"
  value       = aws_cognito_user_pool_client.this.id
}

output "arn" {
  description = "AWS Cognito user pool arn"
  value       = aws_cognito_user_pool.this.arn
}