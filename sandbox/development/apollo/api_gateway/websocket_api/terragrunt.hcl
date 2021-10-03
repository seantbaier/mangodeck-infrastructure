locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  app_name    = local.account_vars.locals.app_name
  environment = local.environment_vars.locals.environment
}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../..//modules/aws_api_gateway/websocket_api"
}

include {
  path = find_in_parent_folders()
}

dependency "websocket_handler" {
  config_path = "../../websocket_handler"
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  environment            = local.environment
  app_name               = local.app_name
  name                   = "${local.environment}-${local.app_name}-websocket-api"
  lambda_invoke_arn      = dependency.websocket_handler.outputs.invoke_arn
  function_name          = dependency.websocket_handler.outputs.function_name
  throttling_burst_limit = 5000
  throttling_rate_limit  = 10000
}
