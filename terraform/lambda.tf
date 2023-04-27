resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              ="/aws/lambda/${var.function-name}"
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
}

resource "aws_lambda_alias" "test_lambda_alias" {
  name             = "live"
  description      = "a sample description"
  function_name    = aws_lambda_function.example_lambda.arn
  function_version = "$LATEST"
}

resource "aws_lambda_event_source_mapping" "kinesis_click_stream_to_lambda_consumer" {
  batch_size        = 10
  event_source_arn  = aws_kinesis_stream_consumer.click.arn
  function_name     = "${aws_lambda_function.example_lambda.arn}:${aws_lambda_alias.test_lambda_alias.name}"
  starting_position = "TRIM_HORIZON"
}
