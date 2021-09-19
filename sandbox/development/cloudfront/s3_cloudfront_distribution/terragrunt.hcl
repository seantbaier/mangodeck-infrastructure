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
  source = "../../../..//modules/aws_cloudfront/distribution"
}

include {
  path = find_in_parent_folders()
}

dependency "spa_static_bucket" {
  config_path = "../../s3/spa_static_bucket"
}

dependency "certificate" {
  config_path = "../../../globals/acm/certificate"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  environment      = local.environment
  app_name         = local.app_name
  website_endpoint = dependency.spa_static_bucket.outputs.website_endpoint
  aws_s3_bucket_origin = {
    arn                         = dependency.spa_static_bucket.outputs.arn
    id                          = dependency.spa_static_bucket.outputs.id
    bucket_regional_domain_name = dependency.spa_static_bucket.outputs.bucket_regional_domain_name
  }
  aliases             = ["${local.environment}.${local.domain_name}"]
  acm_certificate_arn = dependency.certificate.outputs.arn


  # custom_error_response = {
  #   response_page_path = "index.html"
  #   response_code      = 200
  # }
}
