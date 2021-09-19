variable "user_pool_id" {
  description = "User Pool Id"
  type        = string
}


variable "certificate_arn" {
  description = "AWS ACM arn for domain"
  type        = string
}

variable "domain" {
  description = "Custom domain name"
  type        = string
}

