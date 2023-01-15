
data "archive_file" "sample_archive" {
  type        = "zip"
  source_dir = "../src/${var.path_lambda_processor}/"
  output_path = "../${var.path_deployment_env}/packages/samplearchive.zip"
}


resource "aws_lambda_function" "samplelambda" {
  depends_on = [
    data.archive_file.sample_archive
  ]
  filename         = "../${var.path_deployment_env}/packages/samplearchive.zip"
  function_name    = "sample_lambda"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "app.lambda_handler"
  source_code_hash = data.archive_file.sample_archive.output_base64sha256
  runtime          = "python3.9"
  memory_size      = 256
  timeout          = 300
}


# For debugging purposes only.

resource "null_resource" "sam_metadata_aws_lambda_function_samplelambda" {
    triggers = {
        resource_name = "aws_lambda_function.samplelambda"
        resource_type = "ZIP_LAMBDA_FUNCTION"
        original_source_code = "../src/${var.path_lambda_processor}/"
        built_output_path = "../${var.path_deployment_env}/packages/samplearchive.zip"
    }
}
