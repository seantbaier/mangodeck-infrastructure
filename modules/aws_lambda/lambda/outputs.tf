# Output variable definitions

output "invoke_arn" {
  description = "Invoke ARN of the Lambda"
  value       = aws_lambda_function.this[0].invoke_arn
}

output "arn" {
  description = "ARN of the Lambda"
  value       = aws_lambda_function.this[0].arn
}

output "function_name" {
  description = "AWS Lambda function name."
  value       = aws_lambda_function.this[0].function_name
}

output "version" {
  description = "Version of lambda function"
  value       = aws_lambda_function.this[0].version
}

output "role_name" {
  description = "ARN of the role attatched to the lambda"
  value       = aws_iam_role.this[0].name
}
