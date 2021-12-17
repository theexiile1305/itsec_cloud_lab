data "archive_file" "processing-7875be2c-assignment-8" {
  type             = "zip"
  source_file      = "processing.py"
  output_file_mode = "0666"
  output_path      = "processing.zip"
}

resource "aws_lambda_function" "processing-7875be2c-assignment-8" {
  filename         = data.archive_file.processing-7875be2c-assignment-8.output_path
  source_code_hash = data.archive_file.processing-7875be2c-assignment-8.output_base64sha256
  function_name    = "processing-7875be2c-assignment-8"
  role             = aws_iam_role.processing-7875be2c-assignment-8.arn
  handler          = "processing.lambda_handler"
  runtime          = "python3.9"
  tags = {
    Name       = "7875be2c"
    user       = "7875be2c"
    assignment = "8-9"
  }
}

resource "aws_s3_bucket_notification" "processing-7875be2c-assignment-8" {
  bucket = aws_s3_bucket.bucket-7875be2c-assignment-8.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.processing-7875be2c-assignment-8.arn
    events = [
      "s3:ObjectCreated:*"
    ]
    filter_prefix = "request/"
    filter_suffix = ".crt"
  }
  depends_on = [aws_lambda_permission.processing_allow_bucket]
}

resource "aws_lambda_permission" "processing_allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processing-7875be2c-assignment-8.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket-7875be2c-assignment-8.arn
}

resource "aws_iam_role" "processing-7875be2c-assignment-8" {
  name = "processing-7875be2c-assignment-8"
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

resource "aws_iam_role_policy" "processing-7875be2c-assignment-8" {
  name = "s3-7875be2c-assignment-8"
  role = aws_iam_role.processing-7875be2c-assignment-8.id
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
          "arn:aws:s3:::bucket-7875be2c-assignment-8/request",
          "arn:aws:s3:::bucket-7875be2c-assignment-8/request/*"
        ]
      },
      {
        Action = [
          "s3:PutObject*",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::bucket-7875be2c-assignment-8/response",
          "arn:aws:s3:::bucket-7875be2c-assignment-8/response/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "processing-7875be2c-assignment-8" {
  role       = aws_iam_role.processing-7875be2c-assignment-8.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}