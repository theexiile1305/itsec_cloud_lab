resource "aws_s3_bucket" "bucket-7875be2c-assignment-8" {
  bucket        = "bucket-7875be2c-assignment-8"
  force_destroy = true
  versioning {
    enabled = false
  }
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "lambda-request",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::145214354801:role/iam-7875be2c-assignment-8"
          ]
        },
        "Action" : "s3:PutObject*",
        "Resource" : [
          "arn:aws:s3:::bucket-7875be2c-assignment-8/request",
          "arn:aws:s3:::bucket-7875be2c-assignment-8/request/*"
        ]
      },
      {
        "Sid" : "lambda-processing-1",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::145214354801:role/processing-7875be2c-assignment-8"
          ]
        },
        "Action" : [
          "s3:GetObject*",
          "s3:DeleteObject*"
        ],
        "Resource" : [
          "arn:aws:s3:::bucket-7875be2c-assignment-8/request",
          "arn:aws:s3:::bucket-7875be2c-assignment-8/request/*"
        ]
      },
      {
        "Sid" : "lambda-processing-2",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::145214354801:role/processing-7875be2c-assignment-8"
          ]
        },
        "Action" : "s3:PutObject*",
        "Resource" : [
          "arn:aws:s3:::bucket-7875be2c-assignment-8/response",
          "arn:aws:s3:::bucket-7875be2c-assignment-8/response/*"
        ]
      },
      {
        "Sid" : "lambda-response-1",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::145214354801:role/response-7875be2c-assignment-8"
          ]
        },
        "Action" : [
          "s3:GetObject*",
          "s3:DeleteObject*"
        ],
        "Resource" : [
          "arn:aws:s3:::bucket-7875be2c-assignment-8/response",
          "arn:aws:s3:::bucket-7875be2c-assignment-8/response/*"
        ]
      },
      {
        "Sid" : "lambda-response-2",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::145214354801:role/response-7875be2c-assignment-8"
          ]
        },
        "Action" : "s3:GetObject*",
        "Resource" : [
          "arn:aws:s3:::bucket-7875be2c-assignment-8/done",
          "arn:aws:s3:::bucket-7875be2c-assignment-8/done/*"
        ]
      }
    ]
  })
  tags = {
    Name       = "7875be2c"
    user       = "7875be2c"
    assignment = "8"
  }
}