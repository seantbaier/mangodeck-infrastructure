variable "environment" {
  description = "Environment the resource is provisioned in."
  type        = string
}

variable "app_name" {
  description = "Application/project name."
  type        = string
}


variable "domain_name" {
  description = "Domain for hosted UI"
  type        = string
}

variable "zone_id" {
  description = "The ID of the hosted zone to contain this record."
  type        = string
}

variable "post_confirmation_lambda_arn" {
  description = "Post confirmation user pool trigger lambda"
  type        = string
}
