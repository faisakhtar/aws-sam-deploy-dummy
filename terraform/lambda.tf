
data "archive_file" "sampletf_archive" {
  type        = "zip"
  source_dir = "../functions/tf/"
  output_path = "../packages/sampletf.zip"
}

data "archive_file" "sampletf2_archive" {
  type        = "zip"
  source_file = "../functions/tf2/app.py"
  output_path = "../packages/sampletf2.zip"
}

data "archive_file" "local_sampletf2_archive" {
  type        = "zip"
  source_file = "../functions/tf2/app.py"
  output_path = "locallambdas/sampletf2.zip"
}


resource "aws_lambda_function" "sampletf" {
  depends_on = [
    data.archive_file.sampletf_archive
  ]
  filename         = "../packages/sampletf.zip"
  function_name    = "sampletf"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "app.lambda_handler"
  source_code_hash = data.archive_file.sampletf_archive.output_base64sha256
  runtime          = "python3.9"
  memory_size      = 256
  timeout          = 300

  environment {
    variables = {
      EXAMPLE_VARIABLE = "example value"
    }
  }
  tags = {
    env   = var.env
    Owner = "Faisal"
  }
}


resource "aws_lambda_function" "sampletf2" {

  depends_on = [
    data.archive_file.sampletf2_archive
  ]
  filename         = "../packages/sampletf2.zip"
  function_name    = "sampletf2"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "app.lambda_handler"
  source_code_hash = data.archive_file.sampletf2_archive.output_base64sha256
  runtime          = "python3.9"
  memory_size      = 256
  timeout          = 300
  environment {
    variables = {
      env   = "dev"
      owner = "faisal"
    }
  }
  tags = {
    env   = var.env
    Owner = "Faisal"
  }
}


resource "null_resource" "sam_metadata_aws_lambda_function_sampletf2" {
    triggers = {
        resource_name = "aws_lambda_function.sampletf2"
        resource_type = "ZIP_LAMBDA_FUNCTION"
        original_source_code = "../functions/tf2"
       # built_output_path = "locallambdas/sampletf2.zip" # The location of this could not be found when using ../functions/tf2/etc.
        built_output_path = "../${path.module}/packages/sampletf2.zip" # The location of this could not be found when using ../functions/tf2/etc.
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
