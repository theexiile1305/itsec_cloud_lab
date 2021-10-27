terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

# create s3 bucket
resource "aws_s3_bucket" "assignment_3" {
  bucket        = "7875be2c-assignment-3"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# bucket policy for 7875be2c-assignment-3 bucket
resource "aws_s3_bucket_policy" "assignment_3" {
  bucket = aws_s3_bucket.assignment_3.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "assignment-3-bucket-policy"
    Statement = [
      {
        Sid    = "OnlyAllowCrudOperation"
        Effect = "Deny"
        NotPrincipal = {
          "AWS" : "arn:aws:iam::145214354801:user/7875be2c"
        },
        Action = ["s3:*"]
        Resource = [
          "${aws_s3_bucket.assignment_3.arn}",
          "${aws_s3_bucket.assignment_3.arn}/C.txt",
        ]
      },
      {
        Sid    = "OnlyAllowReadOperation"
        Effect = "Deny"
        NotPrincipal = {
          "AWS" : "arn:aws:iam::145214354801:user/7875be2c",
        },
        Action = [
          "s3:Delete*",
          "s3:PutObject*",
          "s3:AbortMultipartUpload",
          "s3:RestoreObject"
        ]
        Resource = ["${aws_s3_bucket.assignment_3.arn}/I.txt"]
      },
      {
        Sid    = "OnlyAllowReadAndModifyOperation"
        Effect = "Deny"
        NotPrincipal = {
          "AWS" : "arn:aws:iam::145214354801:user/7875be2c",
        },
        Action = [
          "s3:Delete*",
          "s3:AbortMultipartUpload",
          "s3:RestoreObject"
        ]
        Resource = ["${aws_s3_bucket.assignment_3.arn}/A.txt"]
      }
    ]
  })
}
