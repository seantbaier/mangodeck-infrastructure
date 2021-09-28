variable "create" {
  description = "Create resource conditionally."
  type        = bool
  default     = true
}

variable "env" {
  description = "Environment the resource is provisioned in."
  type        = string
}

variable "app_name" {
  description = "Application/project name."
  type        = string
}

variable "tags" {
  description = "AWS resrouce tags."
  type        = map(any)
  default     = {}
}

variable "name" {
  description = "Name for the AWS resource."
  type        = string
}

variable "protocol_type" {
  description = "(Required) The API protocol. Valid values: HTTP, WEBSOCKET."
  type        = string
}

variable "integration_type" {
  description = "(Required) The integration type of an integration. Valid values: AWS (supported only for WebSocket APIs), AWS_PROXY, HTTP (supported only for WebSocket APIs), HTTP_PROXY, MOCK (supported only for WebSocket APIs). For an HTTP API private integration, use HTTP_PROXY."
  type        = string
}

variable "integration_method" {
  description = "(Optional) The integration's HTTP method. Must be specified if integration_type is not MOCK."
  type        = string
}

variable "integration_uri" {
  description = "(Optional) The URI of the Lambda function for a Lambda proxy integration, when integration_type is AWS_PROXY. For an HTTP integration, specify a fully-qualified URL. For an HTTP API private integration, specify the ARN of an Application Load Balancer listener, Network Load Balancer listener, or AWS Cloud Map service."
  type        = string
}

variable "payload_format_version" {
  description = "(Optional) The format of the payload sent to an integration. Valid values: 1.0, 2.0. Default is 1.0."
  type        = string
  default     = "1.0"
}

variable "domain_name" {
  description = "(Required) The domain name. Must be between 1 and 512 characters in length."
  type        = string
}

variable "certificate_arn" {
  description = "(Required) The ARN of an AWS-managed certificate that will be used by the endpoint for the domain name. AWS Certificate Manager is the only supported source. Use the aws_acm_certificate resource to configure an ACM certificate."
  type        = string
}

variable "endpoint_type" {
  description = "(Required) The endpoint type. Valid values: REGIONAL."
  type        = string
}

variable "security_policy" {
  description = "(Required) The Transport Layer Security (TLS) version of the security policy for the domain name. Valid values: TLS_1_2."
  type        = string
}
