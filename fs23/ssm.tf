resource "aws_ssm_parameter" "sample_ssm" {
  name  = "/sample/ssmparam"
  type  = "String"
  value = "ssmparam"

  tags = {
      env = var.env
  }
}