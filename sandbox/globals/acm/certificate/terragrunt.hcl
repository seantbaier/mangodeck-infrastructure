locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  app_name    = local.account_vars.locals.app_name
  domain_name = local.account_vars.locals.domain_name
}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/aws_acm/certificate"
}

include {
  path = find_in_parent_folders()
}

dependency "hosted_zone" {
  config_path = "../../route53/hosted_zone"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  app_name                  = local.app_name
  domain_name               = local.domain_name
  subject_alternative_names = ["*.${local.domain_name}"]
  validation_method         = "DNS"
  zone_id                   = dependency.hosted_zone.outputs.zone_id
}
