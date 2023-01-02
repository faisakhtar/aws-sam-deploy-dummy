terraform {
  backend "s3" {
    bucket = "${aws_s3_bucket.terraform_state.id}"
    key = "state.tfstate"
    region = "us-east-1"
  }
}