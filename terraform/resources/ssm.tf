resource "aws_ssm_parameter" "sample_module" {
  name  = "/sample/module"
  type  = "String"
  value = "modulessmparam"

  tags = {
      env = var.env
  }
}