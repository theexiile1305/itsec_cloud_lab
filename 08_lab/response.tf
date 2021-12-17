data "archive_file" "response-7875be2c-assignment-8" {
  type             = "zip"
  source_file      = "response.py"
  output_file_mode = "0666"
  output_path      = "response.zip"
}

resource "aws_lambda_function" "response-7875be2c-assignment-8" {
  filename         = data.archive_file.response-7875be2c-assignment-8.output_path
  source_code_hash = data.archive_file.response-7875be2c-assignment-8.output_base64sha256
  function_name    = "response-7875be2c-assignment-8"
  role             = aws_iam_role.response-7875be2c-assignment-8.arn
  handler          = "response.lambda_handler"
  runtime          = "python3.9"
  tags = {
    Name       = "7875be2c"
    user       = "7875be2c"
    assignment = "8-9"
  }
}

resource "aws_s3_bucket_notification" "response-7875be2c-assignment-8" {
  bucket = aws_s3_bucket.bucket-7875be2c-assignment-8.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.response-7875be2c-assignment-8.arn
    events = [
      "s3:ObjectCreated:*"
    ]
    filter_prefix = "response/"
    filter_suffix = ".crt"
  }
  depends_on = [aws_lambda_permission.response_allow_bucket]
}

resource "aws_lambda_permission" "response_allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.response-7875be2c-assignment-8.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket-7875be2c-assignment-8.arn
}

resource "aws_iam_role" "response-7875be2c-assignment-8" {
  name = "response-7875be2c-assignment-8"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name       = "7875be2c"
    user       = "7875be2c"
    assignment = "8-9"
  }
}

resource "aws_iam_role_policy" "response-7875be2c-assignment-8" {
  name = "s3-7875be2c-assignment-8"
  role = aws_iam_role.response-7875be2c-assignment-8.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject*",
          "s3:DeleteObject*"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::bucket-7875be2c-assignment-8/response",
          "arn:aws:s3:::bucket-7875be2c-assignment-8/response/*"
        ]
      },
      {
        Action = [
          "s3:PutObject*",
          "s3:GetObject*"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::bucket-7875be2c-assignment-8/done",
          "arn:aws:s3:::bucket-7875be2c-assignment-8/done/*"
        ]
      },
      {
        Action   = "ses:SendEmail"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "response-7875be2c-assignment-8" {
  role       = aws_iam_role.response-7875be2c-assignment-8.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}