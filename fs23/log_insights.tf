resource "aws_cloudwatch_query_definition" "event_bridge_rule_triggers_query" {
  name = "fs023-eventbridge_rule_triggers"

  log_group_names = [
    "/aws/lambda/unittesting"
  ]

  query_string = <<EOF
fields @timestamp,@log, @message
| sort @timestamp desc
EOF
}


resource "aws_cloudwatch_query_definition" "lambda_invocations_by_request_id_query" {
  name = "fs023-lambda_invocations_by_request_id"

  log_group_names = [
    "/aws/lambda/unittesting"
  ]

  query_string = <<EOF
fields @timestamp, @logStream, @message
| sort @timestamp desc
| filter @message like /START RequestId/
| parse @message "RequestId: *" as request_id
EOF
}
