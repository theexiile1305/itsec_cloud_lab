import base64
import boto3
import json

bucket = '7875be2c-assignment-6'
s3 = boto3.client('s3')

def lambda_handler(event, context):
    headers = event['headers']
    jwt = headers['authorization']
    jwtDataBase64 = jwt.split(".")[1]
    jwtData = json.loads(base64.b64decode(jwtDataBase64).decode('utf-8'))
    directGroups = jwtData['groups_direct']
    
    if bucket in directGroups:
        jsonBody = json.loads(event['body'])
        key = jsonBody['path']
        body = base64.b64decode(jsonBody['blob'])
        
        s3.put_object(
            Bucket=bucket,
            Key=key,
            Body=body
        )
        
        return {
            "statusCode": 200,
            "body": "You've granted access to your requested resource!"
        }
    else:
        return {
            "statusCode": 401,
            "body": "You've not allowed to access your requested resource!"
        }