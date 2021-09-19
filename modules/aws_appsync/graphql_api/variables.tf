variable "name" {
  description = "Name for graphql api"
  type        = string
}

variable "user_pool_id" {
  description = "User pool id for Cognito auth"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}
