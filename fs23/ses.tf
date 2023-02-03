
resource "aws_ses_template" "ses_basic_email" {
  name      = "basic_email_template"
  subject   = "Example Subject"
  text     = "Hello World! This is an example email template.\n This is for: {{name}}"
}