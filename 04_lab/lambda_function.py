import json
import time
import boto3
import datetime

iam = boto3.client('iam')
ses = boto3.client('ses')

def lambda_handler(event, context):
    nextDenyTime = datetime.datetime.utcnow() + datetime.timedelta(hours=1)
    nextDenyTime = nextDenyTime.strftime("%Y-%m-%dT%H:%M:%SZ")
    policy = {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Deny",
                "Action": [
                    "sts:AssumeRole",
                    "sts:AssumeRoleWithSAML",
                    "sts:AssumeRoleWithWebIdentity"
                ],
                "Resource": "*",
                "Condition": {
                    "DateGreaterThan": {
                        "aws:CurrentTime": nextDenyTime
                    },
                }
            }
        ]
        
    }
    
    response = iam.put_user_policy(
        UserName="7875be2c",
        PolicyName="7875be2c-assignment-4",
        PolicyDocument=json.dumps(policy)
    )
    
    response = ses.send_email(
        Source='michael.fuchs@hm.edu',
        Destination={
            'ToAddresses': [ 'michael.fuchs@hm.edu',]
        },
        Message={
            'Subject': {
                'Data': "'You've successfully granted accces to sts:assumeRole for the next hour."
            },
            'Body': {
                'Text': {
                    'Data': "You've successfully granted accces to sts:assumeRole for the next hour (until {} UTC).".format(nextDenyTime)
                }
            }
        }
    )
    
    return {
        'statusCode': 200,
        'body': "Policy changed succesfully, you can assume roles until {} UTC.".format(nextDenyTime)
    }
