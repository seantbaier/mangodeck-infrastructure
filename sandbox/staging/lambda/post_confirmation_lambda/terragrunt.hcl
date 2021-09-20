locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  app_name       = local.account_vars.locals.app_name
  aws_account_id = local.account_vars.locals.aws_account_id
  environment    = local.environment_vars.locals.environment
  function_name  = "${local.environment}-post-confirmation-lambda"
}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/aws_lambda/lambda"
}

include {
  path = find_in_parent_folders()
}

dependency "post_confirmation_lambda" {
  config_path = "../../s3/post_confirmation_lambda"
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  function_name = "${local.environment}-post-confirmation-lambda"
  environment   = local.environment
  s3_key        = "function.zip"
  s3_bucket     = dependency.post_confirmation_lambda.outputs.bucket
  runtime       = "python3.8"

  role_name        = "${local.environment}-post-confirmation-lambda-role"
  trusted_entities = ["cognito-idp.amazonaws.com", "lambda.amazonaws.com"]
  environment_variables = {
    LOG_LEVEL = "debug"
  }

  tags = {
    Name        = local.function_name
    Terraform   = "true"
    Environment = local.environment
  }
}
