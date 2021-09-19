resource "aws_appsync_graphql_api" "this" {
  authentication_type = "AMAZON_COGNITO_USER_POOLS"
  name                = var.name

  user_pool_config {
    aws_region     = var.aws_region
    default_action = "DENY"
    user_pool_id   = var.user_pool_id
  }
}
