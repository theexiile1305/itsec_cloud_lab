
# Assignment 3: Data Protection Game
## Rule
In this exercise, you may not modify the IAM users of Prof. Ebke or other students.

## Phase 1 - should be done until Friday afternoon
You are tasked with creating and protecting three different files in three different ways.
- The file "C.txt" should be Confidential. Put a string into it that only you know. Your goal is to put this file in S3 in a way that you can retrieve and read it later, but nobody else can.
- The file "I.txt" (containing your IAM username) is a file that should be readable by other users, but should not be modifiable.
- The file "A.txt" (containing your IAM username) should be readable and modifiable by all users, but it should be impossible to remove it.

To hand this assignment in, send me an email with the buckets of the three files, including the secret string.

## Phase 2 - after Friday Afternoon
Now you can test the defenses of your colleagues - try to collect as many secrets in "C.txt" files as possible!

**Extra**: Try to remove A.txt files and modify I.txt files!

---

## Solution: use documentation of terraform
- create aws s3 bucket in order to upload all three files
- create aws s3 bucket policy so that the files are secured like mentiond above

---

## Important links
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_bucket_policy
- https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-arns
