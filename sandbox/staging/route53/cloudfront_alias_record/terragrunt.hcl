locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  environment = local.environment_vars.locals.environment
  domain_name = local.account_vars.locals.domain_name
  record_name = "${local.environment}.${local.domain_name}"

}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/aws_route53/alias_record"
}

include {
  path = find_in_parent_folders()
}

dependency "hosted_zone" {
  config_path = "../../../globals/route53/hosted_zone"
}

dependency "s3_cloudfront_distribution" {
  config_path = "../../cloudfront/s3_cloudfront_distribution"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name    = local.record_name
  zone_id = dependency.hosted_zone.outputs.zone_id
  type    = "A"
  alias = {
    name                   = dependency.s3_cloudfront_distribution.outputs.domain_name
    zone_id                = "Z2FDTNDATAQYW2" // HardCoded value for CloudFront
    evaluate_target_health = false
  }
}
