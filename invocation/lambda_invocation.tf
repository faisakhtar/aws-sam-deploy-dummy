resource "aws_lambda_invocation" "example_lambda_invoke" {
  function_name = "sampletf"

  # Optional arguments to pass to the function
  input = jsonencode({
    key1 = "value1"
    key2 = "value2"
    key3 = "value3"
  })
}

output "result_entry" {
  value = jsondecode(aws_lambda_invocation.example_lambda_invoke.result)
}