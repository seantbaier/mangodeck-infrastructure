output "id" {
  description = "Id of AWS Secret"
  value       = aws_secretsmanager_secret.this.id
}
