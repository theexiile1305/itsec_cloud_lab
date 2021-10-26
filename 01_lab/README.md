# Assignment 1: CloudTrail is watching you

Create a CloudTrail that monitors your activity. Use Terraform to create and manage the CloudTrail.
You cannot filter the events from the CloudTrail side at the required granularity - Log everything to CloudWatch Logs and filter for your own activity there.
Verify that your activities turn up there!

Bonus: Use the Access Analyzer on your CloudTrail to generate a minimal policy.

---

## Solution: use documentation of terraform
- create aws cloud trail resource
- create s3 bucket in order to save cloud trail
- writing cloud trail events to cloudwatch log group
  - aws role is here required, so that cloud trails can be read and written to cloud watch
  - required policy for given iam role 'cloudtrail_iam_cloudwatch'
- create resource aws_accessanalyzer_analyzer 

---

## Important links
### Terraform
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/accessanalyzer_analyzer

### AWS console
-  https://s3.console.aws.amazon.com/s3/buckets/mfuchs-trail-logs-activities?region=eu-central-1&tab=objects
- https://eu-central-1.console.aws.amazon.com/cloudtrail/home?region=eu-central-1#/trails
- https://eu-central-1.console.aws.amazon.com/cloudwatch/home?region=eu-central-1#logsV2:log-groups/log-group/mfuchs-cloudwatch-activities
- https://console.aws.amazon.com/iam/home#/roles/mfuchs-cloudtrail-to-cloudwatch
- https://eu-central-1.console.aws.amazon.com/access-analyzer/home?region=eu-central-1#/findings

---

## Hints
- AWS has internal security controls. To allow CloudTrail to send logs to CloudWatch, you have to give it permission.
- The permission comes in form of a "Role" that CloudTrail can "assume", and which has permission to write to cloudwatch.
- You therefore need two ressources: The Role with a policy that describes who can assume the role and the policy that allows the role holder to write to cloudwatch
- (If this is confusing, that's OK - we'll work on this in depth more!)
- Below is some terraform code which creates such a role. Scroll down to see it.
```
resource "aws_iam_role" "cloudtrail_iam_cloudwatch" {
  name = "cloudtrail-to-cloudwatch"

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

resource "aws_iam_role_policy" "cloudtrail_iam_cloudwatch" {
  name = "cloudtrail-iam-cloudwatch"
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
```