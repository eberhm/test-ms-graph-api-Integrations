resource "aws_sqs_queue" "test_queue" {
  name                      = "${var.environment}-${var.name}-test-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
}