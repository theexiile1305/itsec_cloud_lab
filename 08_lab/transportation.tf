resource "aws_sqs_queue" "sqs-fifo-7875be2c-assignment-8" {
  name                        = "sqs-7875be2c-assignment-8.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  tags = {
    Name       = "sqs-fifo-7875be2c"
    user       = "7875be2c"
    assignment = "8"
  }
}