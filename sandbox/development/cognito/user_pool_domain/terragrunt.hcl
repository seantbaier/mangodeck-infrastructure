locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  domain_name = local.account_vars.locals.domain_name
  environment = local.environment_vars.locals.environment
  domain      = "${local.environment}-auth.${local.domain_name}"
}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/aws_cognito/user_pool_domain"
}

include {
  path = find_in_parent_folders()
}

dependency "aws_acm_certificate" {
  config_path = "../../../globals/acm/certificate"
}

dependency "user_pool" {
  config_path = "../user_pool"
}

dependency "auth_alias_record" {
  config_path = "../../../globals/route53/auth_alias_record"
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  domain          = local.domain
  user_pool_id    = dependency.user_pool.outputs.id
  certificate_arn = dependency.aws_acm_certificate.outputs.arn
}
