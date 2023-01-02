resource "aws_s3_bucket" "s3_terraform_state" {
  bucket = "terraform"
  acl = "private"
}