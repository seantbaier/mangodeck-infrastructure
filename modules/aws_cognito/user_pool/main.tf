locals {
  tags = {
    Terraform   = true
    App         = var.app_name
    Environment = var.environment
  }
}

resource "aws_cognito_user_pool" "this" {
  name                     = "${var.environment}-${var.app_name}-user-pool"
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  verification_message_template {
    default_email_option  = "CONFIRM_WITH_CODE"
    email_message_by_link = "Click the link to confirm your email address {##Click Here##}"
    email_subject_by_link = "Please confirm your email address."
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  username_configuration {
    case_sensitive = false
  }

  schema {
    name                     = "email"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false
    required                 = true


    string_attribute_constraints {
      min_length = 3
      max_length = 35
    }
  }

  schema {
    name                     = "userGroup"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false


    string_attribute_constraints {
      min_length = 3
      max_length = 35
    }
  }

  mfa_configuration          = "OPTIONAL"
  sms_authentication_message = "Your code is {####}"

  # sms_configuration {
  # external_id    = "example"
  # sns_caller_arn = aws_iam_role.example.arn
  # }

  software_token_mfa_configuration {
    enabled = true
  }


  lambda_config {
    post_confirmation = var.post_confirmation_lambda_arn
  }


  tags = local.tags
}

resource "aws_cognito_user_pool_client" "this" {
  name = "${var.environment}-${var.app_name}-web-client"

  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret        = false
  refresh_token_validity = 7
  access_token_validity  = 60
  id_token_validity      = 60

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

  explicit_auth_flows = ["ALLOW_USER_SRP_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  allowed_oauth_flows                  = ["code"]
  callback_urls                        = ["http://localhost:3000"]
  allowed_oauth_scopes                 = ["email", "openid", "profile", "phone", "aws.cognito.signin.user.admin"]
  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = true
  prevent_user_existence_errors        = "ENABLED"

}


resource "aws_cognito_user_group" "superAdmin" {
  name         = "superAdmin"
  user_pool_id = aws_cognito_user_pool.this.id
  precedence   = 1
  description  = "Super Admin user group"
}


resource "aws_cognito_user_group" "admin" {
  name         = "admin"
  user_pool_id = aws_cognito_user_pool.this.id
  precedence   = 2
  description  = "Admin user group"
}


resource "aws_cognito_user_group" "seller" {
  name         = "seller"
  user_pool_id = aws_cognito_user_pool.this.id
  precedence   = 3
  description  = "Seller user group"
}


resource "aws_cognito_user_group" "virtualAssistant" {
  name         = "virtualAssistant"
  user_pool_id = aws_cognito_user_pool.this.id
  precedence   = 4
  description  = "Virtual Assistant user group"
}


