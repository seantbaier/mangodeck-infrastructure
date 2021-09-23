locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  app_name     = local.account_vars.locals.app_name
  account_name = local.account_vars.locals.account_name
}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/aws_s3/s3_bucket"
}

include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  environment             = local.account_name
  bucket                  = "${local.account_name}-${local.app_name}-assets"
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  create_policy           = false
}
