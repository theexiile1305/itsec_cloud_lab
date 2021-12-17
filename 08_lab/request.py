import base64
import boto3
from json import loads

bucket = 'bucket-7875be2c-assignment-8'
givenGroup = '7875be2c-assignment-6'
s3 = boto3.client('s3')

def lambda_handler(event, context):
    print("You've been successfully authenticated.")
    print("Requesting to authz against ACME.")
    
    jwt = event['headers']['authorization']
    jwtDataBase64 = jwt.split(".")[1]
    jwtData = loads(base64.b64decode(jwtDataBase64).decode('utf-8'))
    directGroups = jwtData['groups_direct']

    if givenGroup in directGroups:
        print("Successfully authorized with your JWT.")

        jsonBody = loads(event['body'])
        body = base64.b64decode(jsonBody['blob'])
        email = base64.b64encode(jsonBody['email'].encode('utf-8'))
        
        key = "request/{}/ca-request.crt".format(email.decode('utf-8'))

        print("Now the ca-request will be put to s3://{}/{}.".format(bucket, key))

        response = s3.put_object(Bucket = bucket, Key = key, Body = body)
        statusCode = response['ResponseMetadata']['HTTPStatusCode']

        print("Successfully saved the ca request at s3://{}/{} with statusCode={}.".format(bucket, key, str(statusCode)))

        return {
            "statusCode": 200,
            "body": "You've been granted access!"
        }
    else:
        print("Sorry, I cannot give access to you reqeusted resource!")
        return {
            "statusCode": 401,
            "body": "You've not been allowed to access!"
        }