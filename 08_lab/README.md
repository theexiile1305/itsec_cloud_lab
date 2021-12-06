# Assignment 8: ACME Simplified Part I -- Preparations for a Certificate Authority

In this and the subsequent assignment we will try to build an automatic Certificate Authority (CA) for GitLab users. This CA will eventually stamp out certificates that certify that an automated system acts on behalf of a given GitLab group.

The Architecture calls for two elements:
- Complete Isolation of the initial parsing of the request
- A transport that produces an audit log of all valid requests
- A VM isolated from the internet to host a CA key (or control access to a CA key)

**Your assignment**: 
Find and implement a system that receives JSON requests with a  JWT authentication (see Assignment 6) and parses them in an isolated environment. Authorization should proceed if "request.group" matches a group in the OpenID Connect Data. Pass on successfully authenticated requests to the isolated VM via a transport mechanism that produces an audit log of all requests.


## Solution
- Setup API Gateway, which invokes the lambda for the parsing part. The used code for the lambda could be seen in `main.py`
- The logs will be captured in the according log group `arn:aws:logs:eu-central-1:145214354801:log-group:/aws/lambda/lambda-7875be2c-assignment-8:*`
- Setup the isolated vm with all required resources via terraform
- Deploy `sqs-polling.py` script to the isolated vm to get access to all sqs messages.


## Used resources
- API Gateway: `apig-7875be2c-assignment-8`
- Lambda: `arn:aws:lambda:eu-central-1:145214354801:function:lambda-7875be2c-assignment-8`
- CloudWatch: `arn:aws:logs:eu-central-1:145214354801:log-group:/aws/lambda/lambda-7875be2c-assignment-8:*`
- IAM Role: `arn:aws:iam::145214354801:role/iam-7875be2c-assignment-8`
- SQS: `arn:aws:sqs:eu-central-1:145214354801:sqs-7875be2c-assignment-8.fifo`
- Key Pair: `7875be2c-key-8`
- EC2: `i-0daaf3abb05f853c5`
- VPC: `vpc-0a4c2614af5c9ebad`
- VPC Subnet: `subnet-02fd6529207a08eeb`
- Route Table: `rtb-09a7d1239a8842cca`
- Internet Gateway: `igw-07c326e7967bb556d`
- Network ACL: `acl-0eb3c2fddb793d2fc`
- Security Group: `sg-05d9194bd5da73288`


## Links
### Parsing
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_authorizer
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission

### Transportation
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue
- https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sqs.html

### Isolated VM
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association
