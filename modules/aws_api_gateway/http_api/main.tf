locals {
  base_tags = {
    Environment = var.env
    Terraform   = true
    App         = var.app_name
  }

  tags = merge(local.base_tags, var.tags)
}

resource "aws_apigatewayv2_api" "this" {
  count = var.create ? 1 : 0

  name          = var.name
  protocol_type = var.protocol_type

  tags = local.tags
}

resource "aws_apigatewayv2_integration" "this" {
  count = var.create ? 1 : 0

  api_id                 = aws_apigatewayv2_api.this[0].id
  integration_type       = var.integration_type
  integration_method     = var.integration_method
  integration_uri        = var.integration_uri
  payload_format_version = var.payload_format_version
}


resource "aws_apigatewayv2_route" "proxy" {
  count = var.create ? 1 : 0

  api_id    = aws_apigatewayv2_api.this[0].id
  route_key = "ANY /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.this[0].id}"
}

resource "aws_apigatewayv2_stage" "this" {
  count = var.create ? 1 : 0

  api_id = aws_apigatewayv2_api.this[0].id
  name   = "$default"

  auto_deploy = true

  tags = local.tags
}

resource "aws_apigatewayv2_domain_name" "this" {
  count = var.create ? 1 : 0

  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "this" {
  count = var.create ? 1 : 0

  api_id      = aws_apigatewayv2_api.this[0].id
  domain_name = aws_apigatewayv2_domain_name.this[0].id
  stage       = aws_apigatewayv2_stage.this[0].id
}
