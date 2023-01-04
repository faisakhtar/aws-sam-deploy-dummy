# Create an API Gateway REST API
resource "aws_api_gateway_rest_api" "integration_rest_api" {
  name = "integration_rest_api"
}

#

# Create a resource for the POST endpoint
resource "aws_api_gateway_resource" "integration_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.integration_rest_api.id
  parent_id   = aws_api_gateway_rest_api.integration_rest_api.root_resource_id
  path_part   = "integration"
}

resource "aws_api_gateway_method" "integration_method" {
  rest_api_id   = aws_api_gateway_rest_api.integration_rest_api.id
  resource_id   = aws_api_gateway_resource.integration_gateway_resource.id
  http_method   = "POST"
  authorization = "NONE"

  request_parameters = {
    "method.request.header.Content-Type" = true
  }

}


resource "aws_api_gateway_integration" "integration_integration" {
  rest_api_id = aws_api_gateway_rest_api.integration_rest_api.id
  resource_id = aws_api_gateway_resource.integration_gateway_resource.id
  http_method = aws_api_gateway_method.integration_method.http_method

  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.sampletf.invoke_arn
  credentials             = aws_iam_role.iam_for_cognito_credentials.arn
  request_parameters = {
    "integration.request.header.Content-Type" = "method.request.header.Content-Type"
  }

}

resource "aws_api_gateway_deployment" "integration_deployment" {
  rest_api_id = aws_api_gateway_rest_api.integration_rest_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.integration_rest_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "integration_stage" {
  deployment_id = aws_api_gateway_deployment.integration_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.integration_rest_api.id
  stage_name    = "dev"
   depends_on  = [aws_cloudwatch_log_group.cloudwatch_loggroup]
   
#  access_log_settings {
#    destination_arn = aws_cloudwatch_log_group.cloudwatch_loggroup.arn
#    format = "{ \"requestId\": \"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"caller\": \"$context.identity.caller\", \"user\": \"$context.identity.user\", \"requestTime\": \"$context.requestTime\", \"httpMethod\": \"$context.httpMethod\", \"resourcePath\": \"$context.resourcePath\", \"status\": \"$context.status\", \"protocol\": \"$context.protocol\", \"responseLength\": \"$context.responseLength\" }"
#  }
}

resource "aws_api_gateway_method_settings" "integration_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.integration_rest_api.id
  stage_name  = aws_api_gateway_stage.integration_stage.stage_name
  

  method_path = "*/*"
  depends_on  = [aws_cloudwatch_log_group.cloudwatch_loggroup, aws_api_gateway_stage.integration_stage]
  
  settings {
    metrics_enabled = true
    logging_level   = "OFF"
    
  }
}
