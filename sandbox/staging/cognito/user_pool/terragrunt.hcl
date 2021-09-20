locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  domain_name = local.account_vars.locals.domain_name
  environment = local.environment_vars.locals.environment
  app_name    = local.account_vars.locals.app_name
}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/aws_cognito/user_pool"
}

include {
  path = find_in_parent_folders()
}

dependency "hosted_zone" {
  config_path = "../../../globals/route53/hosted_zone"
}

dependency "post_confirmation_lambda" {
  config_path = "../../lambda/post_confirmation_lambda"
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  environment                  = local.environment
  app_name                     = local.app_name
  domain_name                  = local.domain_name
  zone_id                      = dependency.hosted_zone.outputs.zone_id
  post_confirmation_lambda_arn = dependency.post_confirmation_lambda.outputs.arn
}
