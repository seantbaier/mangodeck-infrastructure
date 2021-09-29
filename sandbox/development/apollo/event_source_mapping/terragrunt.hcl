# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/aws_lambda/lambda_event_source_mapping"
}

include {
  path = find_in_parent_folders()
}

dependency "dynamodb_stream_handler" {
  config_path = "../dynamodb_stream_handler"
}

dependency "events_table" {
  config_path = "../dynamodb/events_table"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  function_name    = dependency.dynamodb_stream_handler.outputs.arn
  event_source_arn = dependency.events_table.outputs.dynamodb_table_stream_arn
}
