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
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = <<EOF
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
    }
    EOF
    ignore_changes = [name, arn]
}
