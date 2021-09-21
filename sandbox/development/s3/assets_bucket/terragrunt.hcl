locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  app_name    = local.account_vars.locals.app_name
  environment = local.environment_vars.locals.environment
}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/aws_s3/s3_bucket"
}

include {
  path = find_in_parent_folders()
}

dependency "s3_cloudfront_distribution" {
  config_path = "../../cloudfront/s3_cloudfront_distribution"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  environment             = local.environment
  bucket                  = "${local.environment}-${local.app_name}-assets"
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  create_policy           = false
}
