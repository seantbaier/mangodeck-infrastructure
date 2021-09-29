locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  app_name    = local.account_vars.locals.app_name
  environment = local.environment_vars.locals.environment
}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../..//modules/aws_api_gateway/rest_api"
}

include {
  path = find_in_parent_folders()
}

dependency "http_handler" {
  config_path = "../../http_handler"
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  environment       = local.environment
  app_name          = local.app_name
  name              = "${local.environment}-${local.app_name}-rest-api"
  lambda_invoke_arn = dependency.http_handler.outputs.invoke_arn
  function_name     = dependency.http_handler.outputs.function_name
}
