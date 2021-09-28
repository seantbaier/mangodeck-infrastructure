locals {
  name        = var.name
  environment = var.environment
}

resource "aws_api_gateway_rest_api" "this" {
  name = local.name
}

resource "aws_api_gateway_resource" "rest_api" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "/{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "lambda_proxy" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.rest_api.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_integration" "lambda_proxy" {
  http_method = aws_api_gateway_method.lambda_proxy.http_method
  resource_id = aws_api_gateway_resource.rest_api.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  type        = "AWS_PROXY"
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.rest_api.id,
      aws_api_gateway_method.lambda_proxy.id,
      aws_api_gateway_integration.lambda_proxy.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = local.environment
}




# "ApiGatewayRestApi": {
#       "Type": "AWS::ApiGateway::RestApi",
#       "Properties": {
#         "Name": "dev-graphql-server-demo",
#         "EndpointConfiguration": {
#           "Types": [
#             "EDGE"
#           ]
#         },
#         "Policy": ""
#       }
#     },

################
# Method OPTIONS
#################
#     "ApiGatewayMethodOptions": {
#       "Type": "AWS::ApiGateway::Method",
#       "Properties": {
#         "AuthorizationType": "NONE",
#         "HttpMethod": "OPTIONS",
#         "MethodResponses": [
#           {
#             "StatusCode": "200",
#             "ResponseParameters": {
#               "method.response.header.Access-Control-Allow-Origin": true,
#               "method.response.header.Access-Control-Allow-Headers": true,
#               "method.response.header.Access-Control-Allow-Methods": true
#             },
#             "ResponseModels": {}
#           }
#         ],
#         "RequestParameters": {},
#         "Integration": {
#           "Type": "MOCK",
#           "RequestTemplates": {
#             "application/json": "{statusCode:200}"
#           },
#           "ContentHandling": "CONVERT_TO_TEXT",
#           "IntegrationResponses": [
#             {
#               "StatusCode": "200",
#               "ResponseParameters": {
#                 "method.response.header.Access-Control-Allow-Origin": "'*'",
#                 "method.response.header.Access-Control-Allow-Headers": "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'",
#                 "method.response.header.Access-Control-Allow-Methods": "'OPTIONS,DELETE,GET,HEAD,PATCH,POST,PUT'"
#               },
#               "ResponseTemplates": {
#                 "application/json": "#set($origin = $input.params(\"Origin\"))\n#if($origin == \"\") #set($origin = $input.params(\"origin\")) #end\n#if($origin.matches(\".+\")) #set($context.responseOverride.header.Access-Control-Allow-Origin = $origin) #end"
#               }
#             }
#           ]
#         },
#         "ResourceId": {
#           "Fn::GetAtt": [
#             "ApiGatewayRestApi",
#             "RootResourceId"
#           ]
#         },
#         "RestApiId": {
#           "Ref": "ApiGatewayRestApi"
#         }
#       }
#     },
################
# Method ANY
#################
#     "ApiGatewayMethodAny": {
#       "Type": "AWS::ApiGateway::Method",
#       "Properties": {
#         "HttpMethod": "ANY",
#         "RequestParameters": {},
#         "ResourceId": {
#           "Fn::GetAtt": [
#             "ApiGatewayRestApi",
#             "RootResourceId"
#           ]
#         },
#         "RestApiId": {
#           "Ref": "ApiGatewayRestApi"
#         },
#         "ApiKeyRequired": false,
#         "AuthorizationType": "NONE",
#         "Integration": {
#           "IntegrationHttpMethod": "POST",
#           "Type": "AWS_PROXY",
#           "Uri": {
#             "Fn::Join": [
#               "",
#               [
#                 "arn:",
#                 {
#                   "Ref": "AWS::Partition"
#                 },
#                 ":apigateway:",
#                 {
#                   "Ref": "AWS::Region"
#                 },
#                 ":lambda:path/2015-03-31/functions/",
#                 {
#                   "Fn::GetAtt": [
#                     "HttpHandlerLambdaFunction",
#                     "Arn"
#                   ]
#                 },
#                 "/invocations"
#               ]
#             ]
#           }
#         },
#         "MethodResponses": []
#       }
#     },
#     "ApiGatewayDeployment1632817498411": {
#       "Type": "AWS::ApiGateway::Deployment",
#       "Properties": {
#         "RestApiId": {
#           "Ref": "ApiGatewayRestApi"
#         },
#         "StageName": "dev"
#       },
#       "DependsOn": [
#         "ApiGatewayMethodOptions",
#         "ApiGatewayMethodAny"
#       ]
#     },
#     "HttpHandlerLambdaPermissionApiGateway": {
#       "Type": "AWS::Lambda::Permission",
#       "Properties": {
#         "FunctionName": {
#           "Fn::GetAtt": [
#             "HttpHandlerLambdaFunction",
#             "Arn"
#           ]
#         },
#         "Action": "lambda:InvokeFunction",
#         "Principal": "apigateway.amazonaws.com",
#       }
#     },
