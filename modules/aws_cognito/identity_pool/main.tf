locals {
  auth_domain = "${var.env}-auth.${var.domain_name}"
  tags = {
    Terraform   = true
    App         = var.app_name
    Environment = var.env
  }
}






# resource "aws_cognito_identity_provider" "google" {
#   user_pool_id  = aws_cognito_user_pool.this.id
#   provider_name = "Google"
#   provider_type = "Google"

#   provider_details = {
#     authorize_scopes = "email"
#     client_id        = var.google_client_id
#     client_secret    = var.google_client_secret
#   }

#   attribute_mapping = {
#     email       = "email"
#     family_name = "family_name"
#     given_name  = "given_name"
#     picture     = "picture"
#   }
# }

# resource "aws_cognito_identity_pool" "this" {
#   identity_pool_name               = "${var.env}-${var.app_name}-identity-pool"
#   allow_unauthenticated_identities = false

#   cognito_identity_providers {
#     client_id               = aws_cognito_user_pool_client.this.id
#     provider_name           = "cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool.this.id}"
#     server_side_token_check = true
#   }

#   # cognito_identity_providers {
#   #   client_id               = aws_cognito_user_pool_client.this.id
#   #   provider_name           = aws_cognito_identity_provider.google.provider_name
#   #   server_side_token_check = false
#   # }

#   supported_login_providers = {
#     "accounts.google.com" = var.google_client_id
#   }
# }



