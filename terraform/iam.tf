

resource "aws_iam_role" "iam_for_events" {
  name = "iam_for_events"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "events.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    env   = var.env
    Owner = var.owner
  }

}

resource "aws_iam_role_policy" "iam_for_events_policy" {
  name = "iam_for_events_policy"
  role = aws_iam_role.iam_for_events.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["events:InvokeApiDestination"]
        Effect   = "Allow"
        Sid      = ""
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_policy_for_eb"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["sqs:*", "events:*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  managed_policy_arns = [aws_iam_policy.lambda_policy.arn]


  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    env   = var.env
    Owner = var.owner
  }

}


resource "aws_iam_role" "iam_for_cognito_credentials" {
  name = "iam_for_cognito_credentials"
    managed_policy_arns = [aws_iam_policy.iam_for_api_cloudwatch_logs.arn]
  assume_role_policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Action : "sts:AssumeRole",
          Principal : {
            Service : "apigateway.amazonaws.com"
          },
          Effect : "Allow",
          Sid : ""
        }
      ]
    }
  )
}



resource "aws_iam_policy" "iam_for_api_cloudwatch_logs" {
  name = "iam_for_api_cloudwatch_logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [ "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
