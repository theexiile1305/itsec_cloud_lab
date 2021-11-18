
# Assignment 5: You gotta tag them all
In the cis21 account, a new web service has appeared. Use either [https://github.com/JohannesEbke/aws_list_all](https://github.com/JohannesEbke/aws_list_all), the AWS CLI or the Console to get insight into which resources have been created

Add a tag with your pseudonym as the key and "found" as the value to all taggable resources that you find!

## Solution
Just go the aws console and find all related resources direclty or indirectly attached of the instance `i-00d89d0d1fdceacbb` which is hosting the web server.

### Found resources
- Instances: `i-00d89d0d1fdceacbb`
- Volume: `vol-09a71dc25e381bd31`
- Network Interface: `eni-0ee6314bfc0d201b9`
- AMI: `ami-0a49b025fffbbdac6`
- VPC: `vpc-08544c184d9eae72c`
- DHCP options set: `dopt-063cdce99a339ed8d`
- Internet gateway: `igw-0a902fbb47e978f68`
- Route table: `rtb-0247f10f9feb53106`, `rtb-0ceef19355b8c7863`
- Network ACL: `acl-0f89a0589fd598463`
- Subnet: `subnet-0da79d89a5015196a`, `subnet-03c606248da84c776`
- Security groups: `sg-0cda38b61153695cd`, `sg-05a3ff1bcef2c5454`, `sg-07cf1451aab165176`
- security group rule `sgr-0e3590446f1f2070c`, `sgr-0f166c606aa1534a7`, `sgr-0a6f8731c40c847ea`
- Load balancers: `default-a7qq`
- Target group: `default-a7qq/9b6b0fe1402df13e`
- Website: [http://default-a7qq-1003929042.eu-central-1.elb.amazonaws.com](http://default-a7qq-1003929042.eu-central-1.elb.amazonaws.com)
