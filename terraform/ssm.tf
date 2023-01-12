
data "aws_ssm_parameter" "slack_end_point_parameter" {
  name = "/slack/api"
}