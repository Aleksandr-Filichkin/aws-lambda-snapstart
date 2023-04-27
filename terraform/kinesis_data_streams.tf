#
#resource "aws_kinesis_stream" "click" {
#  name = "Click"
#  retention_period = 24
#
#  stream_mode_details {
#    stream_mode = "ON_DEMAND"
#  }
#}
#
#
#
#resource "aws_kinesis_stream_consumer" "click" {
#  name       = "kinesis-click-stream-consumer"
#  stream_arn = aws_kinesis_stream.click.arn
#}
#
#
