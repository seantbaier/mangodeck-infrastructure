output "id" {
  description = "AWS Cognito user pool id"
  value       = aws_cognito_user_pool.this.id
}

output "user_pool_client_id" {
  description = "AWS Cognito user pool client id"
  value       = aws_cognito_user_pool_client.this.id
}

output "name" {
  description = "AWS Cognito user pool name"
  value       = aws_cognito_user_pool.this.name
}

output "arn" {
  description = "AWS Cognito user pool arn"
  value       = aws_cognito_user_pool.this.arn
}

output "aws_cognito_user_pool_client_id" {
  description = "Client app id"
  value       = aws_cognito_user_pool_client.this.id
}
