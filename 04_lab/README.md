
# Assignment 4: One Lambda to Role them all!
First, remove the general permission to assume roles from your IAM user.
Verify this by trying to assume one of the roles from Assignment 3 and getting a permission error.

Secondly, write a Lambda function that, on invocation, sends an email to you as well as giving you back the permission to assume roles for the duration of one hour.

**Extra**: Create a second lambda that updates the code of the first one, but only by pulling from a git repository with a commit signed by at least two contributors.

---


## Solution
- create a backup user `7875be2c-backup` with an user group `Students`

### Analyze the current situation
- remove general permission to assume roles form your IAM user
    - no user policy assigned
    - no attached user policies assigned
    - current associated group `Students` 
        - with policy `terraform-20211006103046429100000001`, that let the user do crud operations with the access key
        - with attached policies `IAMSelfManageServiceSpecificCredentials`, `AdministratorAccess`, `IAMUserChangePassword`, `IAMReadOnlyAccess`, `IAMUserSSHKeys`. 
        - The policy `AdministratorAccess` let the user do all action on each resources. 

### Solving the exercise
- First of all create a attacted policy named `7875be2c-assignment-4` with a deny effect on the sts resources with a **condition**, wich denies only if the `currentTime` will be greater than the time which the attached policy has been created. From this point of view every time whenever the lambda will be inovekd the current time will be changed.
- Create and verify a ses identity `michael.fuchs@hm.edu` so that aws ses can send emails to your email address.
- Create a role `7875be2c-assignment-4` and a policy `7875be2c-assignment-4` so that the lambda function has permission got permissions `ses:SendEmail`, `iam:PutUserPolicy`,` iam:ListUserPolicies`, `logs:CreateLogGroup`, `logs:CreateLogStream`,`logs:PutLogEvents`
 - Create the lambda function `7875be2c-assignment-4` with the given source code file `lambda_function.py`
 - Finally, verify the functionality of the assignement.


## Used Resources
- SES: `arn:aws:ses:eu-central-1:145214354801:identity/michael.fuchs@hm.edu`
- IAM
    - Role: `arn:aws:iam::145214354801:role/7875be2c-assignment-4`
    - Policy: `arn:aws:iam::145214354801:policy/7875be2c-assignment-4`
- Lambda: `arn:aws:lambda:eu-central-1:145214354801:function:7875be2c-assignment-4`
- CloudWatch: `arn:aws:logs:eu-central-1:145214354801:log-group:/aws/lambda//7875be2c-assignment-4:*`


## Important links
- https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html
- https://aws.amazon.com/getting-started/hands-on/send-an-email/
- https://aws.amazon.com/getting-started/hands-on/run-serverless-code/
- https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sesv2.html
- https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/iam.html
- https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_grammar.html
- https://awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/index.html
- https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sts/index.html
