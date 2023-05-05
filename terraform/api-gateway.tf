resource "aws_api_gateway_rest_api" "example_api" {
  name = "example"
}
resource "aws_api_gateway_resource" "java11_resource" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  parent_id   = aws_api_gateway_rest_api.example_api.root_resource_id
  path_part   = "java11"
}

resource "aws_api_gateway_method" "example_method" {
  rest_api_id   = aws_api_gateway_rest_api.example_api.id
  resource_id   = aws_api_gateway_resource.java11_resource.id
  http_method   = "POST"
  authorization = "NONE"
}
resource "aws_lambda_alias" "api_function_alias_live" {
  name             = "snapstart"
  function_name    = aws_lambda_function.example_lambda.function_name
  function_version = aws_lambda_function.example_lambda.version
}

resource "aws_api_gateway_integration" "example_integration" {
  rest_api_id             = aws_api_gateway_rest_api.example_api.id
  resource_id             = aws_api_gateway_resource.java11_resource.id
  http_method             = aws_api_gateway_method.example_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_alias.api_function_alias_live.invoke_arn

}

# Create a deployment for the API Gateway
resource "aws_api_gateway_deployment" "example_deployment" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  stage_name  = "prod"  # Replace with your desired stage name
  triggers    = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.java11_resource,
      aws_api_gateway_method.example_method,
      aws_api_gateway_integration.example_integration,
      aws_api_gateway_resource.java17_resource,
      aws_api_gateway_method.example_method_java17,
      aws_api_gateway_integration.example_integration_java17,
    ]))
  }

}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.example_lambda.function_name}:${aws_lambda_alias.api_function_alias_live.name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example_api.execution_arn}/*/*"
}

####Java17

resource "aws_api_gateway_resource" "java17_resource" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  parent_id   = aws_api_gateway_rest_api.example_api.root_resource_id
  path_part   = "java17"
}

resource "aws_api_gateway_method" "example_method_java17" {
  rest_api_id   = aws_api_gateway_rest_api.example_api.id
  resource_id   = aws_api_gateway_resource.java17_resource.id
  http_method   = "POST"
  authorization = "NONE"
}
resource "aws_lambda_alias" "api_function_java17_alias_live" {
  name             = "snapstart"
  function_name    = aws_lambda_function.example_lambda_java17.function_name
  function_version = aws_lambda_function.example_lambda_java17.version
}

resource "aws_api_gateway_integration" "example_integration_java17" {
  rest_api_id             = aws_api_gateway_rest_api.example_api.id
  resource_id             = aws_api_gateway_resource.java17_resource.id
  http_method             = aws_api_gateway_method.example_method_java17.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_alias.api_function_java17_alias_live.invoke_arn

}

resource "aws_lambda_permission" "apigw_java17" {
  statement_id  = "AllowAPIGatewayInvoke17"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.example_lambda_java17.function_name}:${aws_lambda_alias.api_function_java17_alias_live.name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example_api.execution_arn}/*/*"
}