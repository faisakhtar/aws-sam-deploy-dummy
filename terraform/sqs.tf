resource "aws_sqs_queue" "terraform_queue" {
  name                      = "terraform-example-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Env = "dev"
    name = "terraform-example-queue"
  }
}

resource "aws_sqs_queue" "terraform_queue2" {
  name                      = "terraform-example-queue2"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Env = "dev"
    name = "terraform-example-queue2"
  }
}