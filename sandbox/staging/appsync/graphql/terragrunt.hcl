locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  app_name    = local.account_vars.locals.app_name
  environment = local.environment_vars.locals.environment
  aws_region  = local.region_vars.locals.aws_region
}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/aws_appsync/graphql_api"
}

include {
  path = find_in_parent_folders()
}

dependency "user_pool" {
  config_path = "../../cognito/user_pool"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name         = "${local.environment}-${local.app_name}"
  user_pool_id = dependency.user_pool.outputs.id
  aws_region   = local.aws_region
}
