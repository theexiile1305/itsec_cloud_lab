resource "aws_iam_policy" "policy-7875be2c-assignment-8" {
  name        = "policy-7875be2c-assignment-8"
  description = "policy deny curd operation on a specific cloudwatch log group"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyCloudWatchModification"
        Effect = "Deny"
        Action = [
          "logs:DisassociateKmsKey",
          "logs:DeleteSubscriptionFilter",
          "logs:UntagLogGroup",
          "logs:DeleteLogGroup",
          "logs:CreateLogGroup",
          "logs:DeleteLogStream",
          "logs:PutLogEvents",
          "logs:CreateExportTask",
          "logs:PutMetricFilter",
          "logs:CreateLogStream",
          "logs:DeleteMetricFilter",
          "logs:TagLogGroup",
          "logs:DeleteRetentionPolicy",
          "logs:AssociateKmsKey",
          "logs:PutSubscriptionFilter",
          "logs:PutRetentionPolicy",
          "logs:CreateLogDelivery",
          "logs:DeleteResourcePolicy",
          "logs:PutResourcePolicy",
          "logs:PutDestinationPolicy",
          "logs:UpdateLogDelivery",
          "logs:CancelExportTask",
          "logs:DeleteLogDelivery",
          "logs:PutQueryDefinition",
          "logs:DeleteDestination",
          "logs:DeleteQueryDefinition",
          "logs:PutDestination"
        ]
        Resource = [
          "arn:aws:logs:eu-central-1:145214354801:log-group:/aws/lambda/request-7875be2c-assignment-8:*",
          "arn:aws:logs:eu-central-1:145214354801:log-group:/aws/lambda/response-7875be2c-assignment-8:*",
          "arn:aws:logs:eu-central-1:145214354801:log-group:/aws/lambda/processing-7875be2c-assignment-8:*"
        ]
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "att-group-7875be2c-assignment-8" {
  group      = "Students"
  policy_arn = aws_iam_policy.policy-7875be2c-assignment-8.arn
}