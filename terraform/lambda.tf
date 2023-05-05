resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              ="/aws/lambda/${var.function-name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group-java17" {
  name              ="/aws/lambda/${var.function-name}-java17"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}
locals {
  lambda_payload_filename = "./../lambda-java/target/lambda-java-1.0-SNAPSHOT.jar"
}
resource "aws_lambda_function" "example_lambda" {
  function_name    = var.function-name
  source_code_hash = base64sha256(filebase64(local.lambda_payload_filename))
  runtime          = "java11"
  handler          = "com.filichkin.blog.lambda.v2.handler.BookHandler::handleRequest"
  filename         = local.lambda_payload_filename
  role             = aws_iam_role.lambda_role.arn
  memory_size      = 256
  timeout          = 20
  snap_start {
    apply_on = "PublishedVersions"
  }
  publish = true
}

resource "aws_lambda_function" "example_lambda_java17" {
  function_name    = "${var.function-name}-java17"
  source_code_hash = base64sha256(filebase64(local.lambda_payload_filename))
  runtime          = "java17"
  handler          = "com.filichkin.blog.lambda.v2.handler.BookHandler::handleRequest"
  filename         = local.lambda_payload_filename
  role             = aws_iam_role.lambda_role.arn
  memory_size      = 256
  timeout          = 20
    snap_start {
      apply_on = "PublishedVersions"
    }
  publish = true
}