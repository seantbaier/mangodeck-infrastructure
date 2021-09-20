locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  domain_name = local.account_vars.locals.domain_name
  app_name    = local.account_vars.locals.app_name
  environment = local.environment_vars.locals.environment
  aws_region  = local.region_vars.locals.aws_region
}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/aws_secrets_manager/secret_version"
}

include {
  path = find_in_parent_folders()
}

dependency "user_pool" {
  config_path = "../../cognito/user_pool"
}

dependency "graphql" {
  config_path = "../../appsync/graphql"
}

dependency "secret" {
  config_path = "../secret"
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name        = local.app_name
  environment = local.environment
  # user_pool_name = dependency.user_pool.outputs.name
  secret_id = dependency.secret.outputs.id

  secrets = {
    "${local.environment}-${local.app_name}" = {
      description = "This is a key/value secret"
      secret_key_value = {
        REACT_APP_ENV               = local.environment
        REACT_APP_BASE_URL          = "https://${local.environment}.seanbaier.com"
        REACT_APP_AMPLIFY_REGION    = local.aws_region
        REACT_APP_GRAPHQL_ENDPOINT  = dependency.graphql.outputs.uris["GRAPHQL"]
        REACT_APP_APPSYNC_AUTH_TYPE = ""
        REACT_APP_USER_POOL_ID      = dependency.user_pool.outputs.id
        REACT_APP_APP_CLIENT_ID     = dependency.user_pool.outputs.aws_cognito_user_pool_client_id
        REACT_APP_AWS_REGION        = local.aws_region
      }
      recovery_window_in_days = 7
    }
  }
}
