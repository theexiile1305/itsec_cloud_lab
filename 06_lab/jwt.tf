resource "aws_apigatewayv2_api" "example" {
  name          = "${local.prefix}-example-http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_authorizer" "example" {
  api_id           = aws_apigatewayv2_api.example.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "LRZ"

  jwt_configuration {
    audience = ["a574074037f2242107c47e03f6474f4b101b98b086112691256e4831d399a4c7"]
    issuer   = "https://gitlab.lrz.de"
  }
}

data "archive_file" "example" {
  type             = "zip"
  source_file      = "main.py"
  output_file_mode = "0666"
  output_path      = "example.zip"
}

resource "aws_lambda_function" "example" {
  filename         = data.archive_file.example.output_path
  source_code_hash = data.archive_file.example.output_base64sha256
  function_name    = "${local.prefix}_jwt_example"
  role             = aws_iam_role.example.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.9"
}

resource "aws_iam_role" "example" {
  name = "${local.prefix}_assignment_6"

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
}

resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.example.execution_arn}/*/$default"
}

resource "aws_apigatewayv2_integration" "example" {
  api_id             = aws_apigatewayv2_api.example.id
  integration_type   = "AWS_PROXY"
  description        = "Lambda example"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.example.invoke_arn
}

resource "aws_apigatewayv2_route" "example" {
  api_id        = aws_apigatewayv2_api.example.id
  route_key     = "$default"
  authorizer_id = aws_apigatewayv2_authorizer.example.id
  target        = "integrations/${aws_apigatewayv2_integration.example.id}"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.example.id
  auto_deploy = true
  name        = "prod"
}
