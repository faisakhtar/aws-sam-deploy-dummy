resource "aws_cloudwatch_event_rule" "examplegit" {
  name        = "example-rule-git"
  description = "Sample deployment using github actions"
  schedule_expression = "cron(0 12 * * ? *)"

  tags = {
    env = var.env
    Owner = "Faisal"
  }
}


resource "aws_cloudwatch_event_rule" "eventbridge_rule_sample" {
  name        = "triggertocloudwatch"
  description = "Sample deployment using terraform"

  event_pattern = <<PATTERN
  {
    "source": [
      "Trigger Cloudwatch Log"
    ]
  }
  PATTERN
  tags = {
    env = var.env
    Owner = var.owner
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_loggroup" {
  name = "/aws/events/terraformsampleloggroup"

  tags = {
    env = var.env
    Owner = var.owner
  }
}

resource "aws_cloudwatch_event_target" "eventbridge_target_sample" {
  rule       = aws_cloudwatch_event_rule.eventbridge_rule_sample.name
  target_id  = "target_1"
  arn        = aws_cloudwatch_log_group.cloudwatch_loggroup.arn

  retry_policy {
    maximum_retry_attempts = 1
    maximum_event_age_in_seconds = 120
  }
  dead_letter_config {
    arn = aws_sqs_queue.terraform_dlq_queue.arn
  }
  input_transformer {
    input_paths = {
      param1 = "$.detail.param1"
      param2 = "$.detail.param2"
    }

    input_template = <<JSON
    {
      "output_param1": <param1>,
      "output_param2": <param2>
    }
    JSON
  }
}