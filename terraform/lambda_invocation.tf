resource "aws_lambda_invocation" "example_lambda_invoke" {
  function_name = "sampletf"

  # Optional arguments to pass to the function
  input = <<EOF
{
  "key1": "value1",
  "key2": "value2"
}
EOF
}