resource "aws_cloudwatch_log_group" "eventbridge_process_data_cloudwatch_loggroup" {
  name              = "/aws/events/process_data"
}