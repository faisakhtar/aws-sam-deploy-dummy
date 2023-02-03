resource "aws_cloudwatch_event_rule" "event_rule_process_data" {
  name        = "process_data"
  description = "Event to Process Data"

  event_pattern  = <<JSON
  {
    "source": [
        "main"
    ]
}
  JSON
}

resource "aws_cloudwatch_event_target" "event_target_process_data_lambda" {
  target_id      = "process_data_lambda_target"
  rule           = aws_cloudwatch_event_rule.event_rule_process_data.name
  arn            = aws_lambda_function.samplelambda.arn
  
  retry_policy {
    maximum_event_age_in_seconds = 60
    maximum_retry_attempts       = 0
  }
  dead_letter_config {
    arn = "arn:aws:sqs:us-east-1:231992682363:Eventbridge-dlq-poc"
  }
}

resource "aws_cloudwatch_event_target" "event_target_process_data_cloudwatch_loggroup" {
  target_id      = "process_data_cloudwatch_target"
  rule           = aws_cloudwatch_event_rule.event_rule_process_data.name
  arn            = aws_cloudwatch_log_group.eventbridge_process_data_cloudwatch_loggroup.arn
}