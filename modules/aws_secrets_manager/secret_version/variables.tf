variable "environment" {
  description = "Environment"
  type        = string
}

# variable "user_pool_id" {
#   description = "User pool id"
#   type        = string
# }

variable "secret_id" {
  description = "AWS Secret Id"
  type        = string
}

variable "secrets" {
  description = "Map of secrets to keep in AWS Secrets Manager"
  type        = any
  default     = {}
}
