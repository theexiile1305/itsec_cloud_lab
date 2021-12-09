import base64
import boto3
from json import loads

queue_url = 'sqs-7875be2c-assignment-8.fifo'
givenGroup = '7875be2c-assignment-6'
sqs = boto3.client('sqs')

def lambda_handler(event, context):
    print("You've been successfully authenticated.")
    print("Requesting to authz against ACME.")
    
    headers = event['headers']
    jwt = headers['authorization']
    jwtDataBase64 = jwt.split(".")[1]
    jwtData = loads(base64.b64decode(jwtDataBase64).decode('utf-8'))
    directGroups = jwtData['groups_direct']

    if givenGroup in directGroups:
        print("Successfully authorized with your JWT.")
        print("Now the information will be pushed further.")

        subject = jwtData['sub']
        iat = str(jwtData['iat'])

        response = sqs.send_message(
            QueueUrl = queue_url,
            MessageGroupId = iat,
            MessageBody = 'Granted access to request resource for user ' + subject + '.'
        )

        print("Successfully send message with to queue, used id=" + response['MessageId'] + ".")

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