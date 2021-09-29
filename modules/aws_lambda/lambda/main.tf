
locals {
  create_role = var.create && var.create_function && var.create_role
  role_name   = local.create_role ? coalesce(var.role_name, var.function_name, "*") : null

  # IAM Role trusted entities is a list of any (allow strings (services) and maps (type+identifiers))
  trusted_entities_services = distinct(compact(concat(
    slice(["lambda.amazonaws.com", "edgelambda.amazonaws.com"], 0, var.lambda_at_edge ? 2 : 1),
    [for service in var.trusted_entities : try(tostring(service), "")]
  )))

  trusted_entities_principals = [
    for principal in var.trusted_entities : {
      type        = principal.type
      identifiers = tolist(principal.identifiers)
    }
    if !can(tostring(principal))
  ]
}

resource "aws_lambda_function" "this" {
  count = var.create_function ? 1 : 0

  function_name = var.function_name
  timeout       = 300
  role          = aws_iam_role.this[0].arn
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  handler       = var.handler
  runtime       = var.runtime

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }
  tags = var.tags
}

data "aws_iam_policy_document" "this" {
  count = local.create_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = local.trusted_entities_services
    }

    dynamic "principals" {
      for_each = local.trusted_entities_principals
      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
  }
}

resource "aws_iam_role" "this" {
  count = local.create_role ? 1 : 0

  name                  = local.role_name
  description           = var.role_description
  path                  = var.role_path
  force_detach_policies = var.role_force_detach_policies
  permissions_boundary  = var.role_permissions_boundary
  assume_role_policy    = data.aws_iam_policy_document.this[0].json
  managed_policy_arns   = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]


  tags = merge(var.tags, var.role_tags)
}
