import json
import boto3
import base64
import urllib.parse

bucketGroup = 'bucket-7875be2c-assignment-8'
prefix = "response"
s3 = boto3.client('s3')
ses = boto3.client('ses')

def lambda_handler(event, context):
    print("Requeting to respond...")

    bucket = event['Records'][0]['s3']['bucket']['name']    
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    
    print("Got new trigger from s3:://{}/{}.".format(bucket, key))

    if prefix in key and bucketGroup in bucket:
        base64Email = key.split('/')[1]
        email = base64.b64decode(base64Email).decode('utf-8')
        targetKey = "done/{}/ca-request.crt".format(base64Email)

        print("Requesting to get object from s3://{}/{}.".format(bucket, key))
        
        response = s3.get_object(Bucket = bucket, Key = key)
        body = response['Body'].read()

        print("Now the ca will be put to s3://{}/{}.".format(bucket, targetKey))

        response = s3.put_object(Bucket = bucket, Key = targetKey, Body = body)
        statusCode = response['ResponseMetadata']['HTTPStatusCode']
        print("Successfully saved the ca request at s3://{}/{} with statusCode={}.".format(bucket, targetKey, str(statusCode)))


        keyCrt = "{}/{}/ca-request.crt".format(prefix, base64Email)
        response = s3.delete_object(Bucket = bucket, Key = keyCrt)
        statusCode = response['ResponseMetadata']['HTTPStatusCode']
        print("Successfully deleted the ca request at s3://{}/{} with statusCode={}.".format(bucket, keyCrt, str(statusCode)))

        keyFolder = "{}/{}".format(prefix, base64Email)
        response = s3.delete_object(Bucket = bucket, Key = keyFolder)
        statusCode = response['ResponseMetadata']['HTTPStatusCode']
        print("Successfully deleted the ca request at s3://{}/{} with statusCode={}.".format(bucket, keyFolder, str(statusCode)))

        response = s3.generate_presigned_url(
            'get_object',
            Params = {
                'Bucket': bucket,
                'Key': targetKey
            },
            ExpiresIn = 3600
        )
        print("Now sending request to user via email={}.".format(email))
        ses.send_email(
            Source='michael.fuchs@hm.edu',
            Destination={ 'ToAddresses': [ email ] },
            Message={
                'Subject': {
                    'Data': "'You're ca request have been successfully procced."
                },
                'Body': {
                    'Text': {
                        'Data': "Your Download-Link with validity of one hour:\n\n{}.".format(response)
                    }
                }
            }
        )

        return { "statusCode": 200 }
    else:
        return { "statusCode": 400 }