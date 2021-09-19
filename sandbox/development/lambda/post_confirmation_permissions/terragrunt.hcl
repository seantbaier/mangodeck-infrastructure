locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  app_name    = local.account_vars.locals.app_name
  environment = local.environment_vars.locals.environment

}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/aws_lambda/lambda_permissions"
}

include {
  path = find_in_parent_folders()
}

dependency "post_confirmation_lambda" {
  config_path = "../post_confirmation_lambda"
}

dependency "user_pool" {
  config_path = "../../cognito/user_pool"
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  function_name                           = dependency.post_confirmation_lambda.outputs.function_name
  function_version                        = dependency.post_confirmation_lambda.outputs.version
  role_name                               = dependency.post_confirmation_lambda.outputs.role_name
  attach_policy_statements                = true
  create_current_version_allowed_triggers = false

  allowed_triggers = {
    CognitoPostConfirmation = {
      service    = "cognito-idp"
      source_arn = dependency.user_pool.outputs.arn
    }
  }

  policy_statements = {
    cognito = {
      effect    = "Allow",
      actions   = ["cognito-idp:AdminAddUserToGroup"],
      resources = [dependency.user_pool.outputs.arn]
    }
  }

  tags = {
    Name        = dependency.post_confirmation_lambda.outputs.role_name
    Terraform   = "true"
    Environment = local.environment
  }
}
