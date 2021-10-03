variable "environment" {
  description = "Environment the resource is provisioned in."
  type        = string
}

variable "app_name" {
  description = "Application/project name."
  type        = string
}

variable "name" {
  description = "REST apigaetway name"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Lambda to invoke for integration"
  type        = string
}

variable "function_name" {
  description = "Lambda to function name for invoke permissions"
  type        = string
}

variable "throttling_burst_limit" {
  description = "(Optional) The throttling burst limit for the default route."
  type        = number
}

variable "throttling_rate_limit" {
  description = "(Optional) The throttling rate limit for the default route."
  type        = number
}

