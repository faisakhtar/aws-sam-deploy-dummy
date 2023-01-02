resource "aws_cloudwatch_event_rule" "examplegit" {
  name        = "example-rule-git"
  description = "Sample deployment using github actions"
  schedule_expression = "cron(0 12 * * ? *)"

  tags = {
    Environment = "POC"
    Owner = "Faisal"
  }
}