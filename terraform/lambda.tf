
#data "archive_file" "init" {
#  type        = "zip"
#  source_file = "../functions/tf/app.py"
#  output_path = "../functions/tf/app.zip"
#}

resource "aws_lambda_function" "sampletf" {
  filename         = "../sampletf.zip"
  function_name    = "sampletf"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "app.lambda_handler"
  source_code_hash = filebase64sha256("../sampletf.zip")
  runtime          = "python3.9"
  memory_size      = 256
  timeout          = 300

  environment {
    variables = {
      EXAMPLE_VARIABLE = "example value"
    }
  }
    tags = {
    env = var.env
    Owner = "Faisal"
  }
}


resource "aws_lambda_function" "sampletf2" {
  filename         = "../sampletf2.zip"
  function_name    = "sampletf2"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "app.lambda_handler"
  source_code_hash = filebase64sha256("../sampletf2.zip")
  runtime          = "python3.9"
  memory_size      = 256
  timeout          = 300
    environment {
    variables = {
      env = "dev"
      owner ="faisal"
    }
  }
    tags = {
    env = var.env
    Owner = "Faisal"
  }
}

resource "aws_lambda_event_source_mapping" "lambda2eventmapping" {
  event_source_arn = aws_sqs_queue.terraform_queue2.arn
  function_name    = aws_lambda_function.sampletf2.arn
  
  depends_on = [
    aws_sqs_queue.terraform_queue2,
    aws_lambda_function.sampletf2
  ]
} 

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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
    env = var.env
    Owner = "Faisal"
  }
  
}