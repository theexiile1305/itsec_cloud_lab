data "archive_file" "arch-7875be2c-assignment-8" {
  type             = "zip"
  source_file      = "main.py"
  output_file_mode = "0666"
  output_path      = "7875be2c-assignment-8.zip"
}

resource "aws_lambda_function" "lambda-7875be2c-assignment-8" {
  filename         = data.archive_file.arch-7875be2c-assignment-8.output_path
  source_code_hash = data.archive_file.arch-7875be2c-assignment-8.output_base64sha256
  function_name    = "lambda-7875be2c-assignment-8"
  role             = aws_iam_role.iam-7875be2c-assignment-8.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.9"
  tags = {
    Name       = "7875be2c"
    user       = "7875be2c"
    assignment = "8"
  }
}

resource "aws_apigatewayv2_api" "apig-7875be2c-assignment-8" {
  name          = "apig-7875be2c-assignment-8"
  protocol_type = "HTTP"
  tags = {
    Name       = "7875be2c"
    user       = "7875be2c"
    assignment = "8"
  }
}

resource "aws_apigatewayv2_authorizer" "authz-7875be2c-assignment-8" {
  api_id           = aws_apigatewayv2_api.apig-7875be2c-assignment-8.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "LRZ"
  jwt_configuration {
    audience = ["6e8b60272881f293e0c2700bf8e9cd511a3b06e3502b4be137d8454c89edaa40"]
    issuer   = "https://gitlab.lrz.de"
  }
}

resource "aws_apigatewayv2_integration" "integration-7875be2c-assignment-8" {
  api_id             = aws_apigatewayv2_api.apig-7875be2c-assignment-8.id
  integration_type   = "AWS_PROXY"
  description        = "Lambda JWT authentication"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.lambda-7875be2c-assignment-8.invoke_arn
}

resource "aws_apigatewayv2_route" "route-7875be2c-assignment-8" {
  api_id        = aws_apigatewayv2_api.apig-7875be2c-assignment-8.id
  route_key     = "$default"
  authorizer_id = aws_apigatewayv2_authorizer.authz-7875be2c-assignment-8.id
  target        = "integrations/${aws_apigatewayv2_integration.integration-7875be2c-assignment-8.id}"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.apig-7875be2c-assignment-8.id
  auto_deploy = true
  name        = "prod"
  tags = {
    Name       = "7875be2c"
    user       = "7875be2c"
    assignment = "8"
  }
}

resource "aws_iam_role" "iam-7875be2c-assignment-8" {
  name = "iam-7875be2c-assignment-8"
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
    assignment = "8"
  }
}

resource "aws_iam_role_policy" "sqs-7875be2c-assignment-8" {
  name = "sqs-7875be2c-assignment-8"
  role = aws_iam_role.iam-7875be2c-assignment-8.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:SendMessage",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:sqs:eu-central-1:145214354801:sqs-7875be2c-assignment-8.fifo"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy-7875be2c-assignment-8" {
  role       = aws_iam_role.iam-7875be2c-assignment-8.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "lambda_permission-7875be2c-assignment-8" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-7875be2c-assignment-8.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.apig-7875be2c-assignment-8.execution_arn}/*/$default"
}