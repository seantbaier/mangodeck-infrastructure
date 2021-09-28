locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  app_name      = local.account_vars.locals.app_name
  environment   = local.environment_vars.locals.environment
  function_name = "${local.environment}-${local.app_name}-handleWebSocket"
}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/aws_lambda/lambda"
}

include {
  path = find_in_parent_folders()
}

dependency "s3_lambda_bucket" {
  config_path = "../s3_lambda_bucket"
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  function_name = local.function_name
  environment   = local.environment
  s3_key        = "function.zip"
  s3_bucket     = dependency.s3_lambda_bucket.outputs.bucket
  runtime       = "nodejs12.x"

  role_name        = "${local.function_name}-lambda-role"
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
