locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  app_name    = local.account_vars.locals.app_name
  environment = local.environment_vars.locals.environment

}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/aws_lambda/lambda_permissions"
}

include {
  path = find_in_parent_folders()
}

dependency "dynamodb_stream_handler" {
  config_path = "../dynamodb_stream_handler"
}

dependency "connections_table" {
  config_path = "../dynamodb/connections_table"
}

dependency "events_table" {
  config_path = "../dynamodb/events_table"
}

dependency "subscriptions_table" {
  config_path = "../dynamodb/subscriptions_table"
}

dependency "subscription_operations_table" {
  config_path = "../dynamodb/subscription_operations_table"
}

# dependency "websocket_api" {
#   config_path = "../api_gateway/websocket_api"
# }


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  function_name                           = dependency.dynamodb_stream_handler.outputs.function_name
  function_version                        = dependency.dynamodb_stream_handler.outputs.version
  role_name                               = dependency.dynamodb_stream_handler.outputs.role_name
  attach_policy_statements                = true
  create_current_version_allowed_triggers = false

  policy_statements = {
    apigateway = {
      effect  = "Allow"
      actions = ["execute-api:ManageConnections"]
      resources = [
        "arn:aws:execute-api:*:*:*/${local.environment}/POST/@connections/*",
        "arn:aws:execute-api:*:*:*/@connections/*"
      ]
    }
    connections = {
      effect = "Allow"
      actions = [
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
      ],
      resources = [dependency.connections_table.outputs.dynamodb_table_arn]
    }
    event_streams = {
      effect = "Allow"
      actions = [
        "dynamodb:DescribeStream",
        "dynamodb:GetRecords",
        "dynamodb:GetShardIterator",
        "dynamodb:ListStreams",
      ],
      resources = [dependency.events_table.outputs.dynamodb_table_stream_arn]
    }
    events = {
      effect = "Allow"
      actions = [
        "dynamodb:PutItem",
      ],
      resources = [dependency.events_table.outputs.dynamodb_table_arn]
    }
    subscriptions = {
      effect = "Allow"
      actions = [
        "dynamodb:BatchWriteItem",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:Query",
        "dynamodb:Scan"
      ],
      resources = [dependency.subscriptions_table.outputs.dynamodb_table_arn]
    }
    subscription_operations = {
      effect = "Allow"
      actions = [
        "dynamodb:BatchWriteItem",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem"
      ],
      resources = [dependency.subscription_operations_table.outputs.dynamodb_table_arn]
    }
  }

  tags = {
    Terraform   = "true"
    Environment = local.environment
  }
}
