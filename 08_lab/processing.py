import boto3
import urllib.parse

bucketGroup = 'bucket-7875be2c-assignment-8'
prefix = "request"
s3 = boto3.client('s3')
ses = boto3.client('ses')

def lambda_handler(event, context):
    print("Requesting to proccess...")
    
    bucket = event['Records'][0]['s3']['bucket']['name']    
    originKey = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    
    print("Got new trigger from s3:://{}/{}.".format(bucket, originKey))

    if prefix in originKey and bucketGroup in bucket:
        base64Email = originKey.split('/')[1]
        targetKey = "response/{}/ca-request.crt".format(base64Email)

        print("Requesting to get object from s3:://{}/{}.".format(bucket, originKey))
        
        response = s3.get_object(Bucket = bucket, Key = originKey)
        body = response['Body'].read()

        print("Now the ca will be put to s3:://{}/{}.".format(bucket, targetKey))

        response = s3.put_object(Bucket = bucket, Key = targetKey, Body = body)
        statusCode = response['ResponseMetadata']['HTTPStatusCode']
        print("Successfully saved the ca request at s3:://{}/{} with statusCode={}.".format(bucket, targetKey, str(statusCode)))

        keyCrt = "{}/{}/ca-request.crt".format(prefix, base64Email)
        response = s3.delete_object(Bucket = bucket, Key = keyCrt)
        statusCode = response['ResponseMetadata']['HTTPStatusCode']
        print("Successfully deleted the ca request at s3://{}/{} with statusCode={}.".format(bucket, keyCrt, str(statusCode)))

        keyFolder = "{}/{}".format(prefix, base64Email)
        response = s3.delete_object(Bucket = bucket, Key = keyFolder)
        statusCode = response['ResponseMetadata']['HTTPStatusCode']
        print("Successfully deleted the ca request at s3://{}/{} with statusCode={}.".format(bucket, keyFolder, str(statusCode)))

        return { "statusCode": 200 }
    else:
        return { "statusCode": 400 }