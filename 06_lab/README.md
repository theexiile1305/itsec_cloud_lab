# Assignment 6: JWTs in Practice

To gain experience in using JWTs to authorize against a web service, we are using GitLab Authentication to get GitLab to sign a JWT, and use that JWT to authenticate to a Lambda. There, we can use e.g. the list of groups to allow people to upload to an S3 bucket, if the filename starts with a group they are part of.

### Step 1:
Clone the code from: https://gitlab.lrz.de/ebke-2021/cis21-assignment6

Modify variables.tf to get a unique prefix for your resources .Use terraform to deploy the Lambda and the API gateway. Test that the generated endpoint is protected by the Authorizer using curl. (You can use the Console to inspect the terraform-generated resources.

### Step 2:
Generate an Application in GitLab. In Settings/Applications, create a new application with a redirect url "http://localhost:8080" and with openid privileges. Save the App ID and App Secret in "appid.txt" and "appsecret.txt" respectively (this is used by demo.py).

### Step 3:
Test getting the code from GitLab, and inspect the JWT. You can use python interactively, copying lines from demo.py. Use jwt.io to inspect and verify the JWT you get.

### Step 4:
Update the App ID in the authorizer in Terraform and run "terraform apply". Now the demo.py should work and you should be able to authorize yourself against the API.

### Step 5 (Bonus):
Now, allow a user to upload (small) files to an S3 bucket, verifying their permission to do so by checking the prefix of the file against a list of their groups.


# Solution
- Clone the code from the references repository
- Modify the file `variables.tf` to get a unique prefix (used: `7875be2c-assignment-6`) for your resources
- Deploy the resources via terraform
    - Init terraform with  `terraform init`
    - Deploy the resources with `terraform apply`
- Generate an application in Gitalb with given requirements
- Save the application id and the secret in the according files
- Update the app id in the authorizer in terraform
- Update the redirect url in the demo.py script
- Update the redirect url in the gitlab application settings
- Apply the changes via `terraform apply`

# Used resources
- API Gateway: `7875be2c-assignment-6-example-http-api`
- Lambda: `arn:aws:lambda:eu-central-1:145214354801:function:7875be2c-assignment-6_jwt_example`
- IAM
    - Role: `7875be2c-assignment-5_assignment_6`
    - Policy: `7875be2c-assignment-6_assignment_6-20211118141631402300000001`
- Endpoint: https://o5260xkl6b.execute-api.eu-central-1.amazonaws.com/prod