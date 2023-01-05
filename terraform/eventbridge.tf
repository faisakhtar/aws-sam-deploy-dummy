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
#  dead_letter_config {
#    arn = aws_sqs_queue.terraform_dlq_queue.arn
#  }
  input_transformer {
    input_paths = {
      param1 = "$.detail.param1"
      param2 = "$.detail.param2"
      param3 = "$.detail.param3"
    }

    input_template = <<JSON
    {
      "output_param1": <param1>,
      "output_param2": <param2>,
      "output_param3": <param3>
    }
    JSON
  }
}

resource "aws_cloudwatch_event_target" "eventbridge_slack_target" {
  rule       = aws_cloudwatch_event_rule.eventbridge_rule_sample.name
  target_id  = "target_2"
  arn = aws_cloudwatch_event_api_destination.slack_event_destination.arn
  role_arn = aws_iam_role.iam_for_events.arn
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
      param3 = "$.detail.param3"
    }

    input_template = <<JSON
    {
      "text": "The first parameter is: <param1>"
    }
    JSON
  }
}

# Create API connection
resource "aws_cloudwatch_event_connection" "slack_event_connection" {
  name               = "slack-terraform-connection"
  description        = "Slack connection via Terraform"
  authorization_type = "API_KEY"

  auth_parameters {
    api_key {
      key   = "apikey"
      value = "apikey"
    }
  }
}

resource "aws_cloudwatch_event_api_destination" "slack_event_destination" {
  name                             = "slack-terraform-destination"
  description                      = "Slack API Destination"
  invocation_endpoint              = data.aws_ssm_parameter.slack_end_point_parameter.value
  http_method                      = "POST"
  invocation_rate_limit_per_second = 20
  connection_arn                   = aws_cloudwatch_event_connection.slack_event_connection.arn
}