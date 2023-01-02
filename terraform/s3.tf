resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform"
  acl = "private"
}