variable "create" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "create_function" {
  description = "Controls whether Lambda Function resource should be created"
  type        = bool
  default     = true
}

variable "create_role" {
  description = "Controls whether IAM role for Lambda Function should be created"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Name of the environment the resources are being deployed to."
  type        = string
  default     = "dev"
}

variable "s3_key" {
  description = "S3 Bucket key"
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket name"
  type        = string
  default     = null
}

variable "runtime" {
  description = "Runtime for lambda function"
  type        = string
  default     = null
}

variable "lambda_at_edge" {
  description = "Set this to true if using Lambda@Edge, to enable publishing, limit the timeout, and allow edgelambda.amazonaws.com to invoke the function"
  type        = bool
  default     = false
}

variable "function_name" {
  description = "Name of function"
  type        = string
}


variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}
}

variable "image_uri" {
  description = "The ECR image URI containing the function's deployment package."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "role_name" {
  description = "Name of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_description" {
  description = "Description of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_force_detach_policies" {
  description = "Specifies to force detaching any policies the IAM role has before destroying it."
  type        = bool
  default     = true
}

variable "role_permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the IAM role used by Lambda Function"
  type        = string
  default     = null
}

variable "role_tags" {
  description = "A map of tags to assign to IAM role"
  type        = map(string)
  default     = {}
}

variable "trusted_entities" {
  description = "List of additional trusted entities for assuming Lambda Function role (trust relationship)"
  type        = any
  default     = []
}

variable "handler" {
  description = "Handler for lambda function to be invoked"
  type = string
  default = null
}