resource "aws_sqs_queue" "integration1_sqs" {
  name                      = "integration-name-queue"
  delay_seconds             = 94
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    env = var.env
  }
}
