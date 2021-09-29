locals {
  app_name    = var.app_name
  environment = var.environment
}

resource "aws_apigatewayv2_api" "websocket" {
  name                       = var.name
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_integration" "websocket" {
  api_id           = aws_apigatewayv2_api.websocket.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_invoke_arn
}

resource "aws_apigatewayv2_route" "default" {
  api_id             = aws_apigatewayv2_api.websocket.id
  authorization_type = "NONE"
  route_key          = "$default"
  target             = "integrations/${aws_apigatewayv2_integration.websocket.id}"
}

resource "aws_apigatewayv2_route" "connect" {
  api_id             = aws_apigatewayv2_api.websocket.id
  authorization_type = "NONE"
  route_key          = "$connect"
  target             = "integrations/${aws_apigatewayv2_integration.websocket.id}"
}

resource "aws_apigatewayv2_route" "disconnect" {
  api_id             = aws_apigatewayv2_api.websocket.id
  authorization_type = "NONE"
  route_key          = "$disconnect"
  target             = "integrations/${aws_apigatewayv2_integration.websocket.id}"
}

resource "aws_apigatewayv2_deployment" "websocket" {
  api_id      = aws_apigatewayv2_route.default.api_id
  description = "${var.environment} deployment"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_apigatewayv2_stage" "websocket" {
  api_id        = aws_apigatewayv2_api.websocket.id
  name          = var.environment
  deployment_id = aws_apigatewayv2_deployment.websocket.id
}

resource "aws_lambda_permission" "websocket" {

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = aws_apigatewayv2_api.websocket.execution_arn
}
