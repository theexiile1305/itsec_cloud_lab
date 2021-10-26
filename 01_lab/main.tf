terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

data "aws_caller_identity" "current" {}

# create s3 bucket in order to save cloud trail
# https://s3.console.aws.amazon.com/s3/buckets/mfuchs-trail-logs-activities?region=eu-central-1&tab=objects
resource "aws_s3_bucket" "trail_logs_activities" {
  bucket        = "mfuchs-trail-logs-activities"
  force_destroy = true
  policy        = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::mfuchs-trail-logs-activities"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::mfuchs-trail-logs-activities/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

# create aws cloud trail resource
# https://eu-central-1.console.aws.amazon.com/cloudtrail/home?region=eu-central-1#/trails
resource "aws_cloudtrail" "trail_own_activities" {
  name                          = "mfuchs-trail-activities"
  s3_bucket_name                = aws_s3_bucket.trail_logs_activities.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
  is_multi_region_trail         = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudwatch_activities.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_iam_cloudwatch.arn

}

# writing cloud trail events to cloudwatch log group
# https://eu-central-1.console.aws.amazon.com/cloudwatch/home?region=eu-central-1#logsV2:log-groups/log-group/mfuchs-cloudwatch-activities
resource "aws_cloudwatch_log_group" "cloudwatch_activities" {
  name = "mfuchs-cloudwatch-activities"
}

# aws role is here required, so that cloud trails can be read and written to cloud watch
# https://console.aws.amazon.com/iam/home#/roles/mfuchs-cloudtrail-to-cloudwatch
resource "aws_iam_role" "cloudtrail_iam_cloudwatch" {
  name = "mfuchs-cloudtrail-to-cloudwatch"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# required policy for given iam role 'cloudtrail_iam_cloudwatch'
# https://console.aws.amazon.com/iam/home#/roles/mfuchs-cloudtrail-to-cloudwatch
resource "aws_iam_role_policy" "cloudtrail_iam_cloudwatch" {
  name = "mfuchs-cloudtrail-iam-cloudwatch"
  role = aws_iam_role.cloudtrail_iam_cloudwatch.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream",
      "Effect": "Allow",
      "Action": ["logs:CreateLogStream"],
      "Resource": [
        "*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents",
      "Effect": "Allow",
      "Action": ["logs:PutLogEvents"],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

# create resource aws_accessanalyzer_analyzer
# https://eu-central-1.console.aws.amazon.com/access-analyzer/home?region=eu-central-1#/findings
resource "aws_accessanalyzer_analyzer" "mfuchs_accessanalyzer" {
  analyzer_name = "mfuchs-accessanalyzer"
}