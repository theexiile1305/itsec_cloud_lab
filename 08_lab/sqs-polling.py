import boto3
import time

queue_url = 'sqs-7875be2c-assignment-8.fifo'
sqs = boto3.client('sqs', region_name = 'eu-central-1')

while True:
    print("No checking for new messages")
    
    response = sqs.receive_message(
        QueueUrl = queue_url,
        MaxNumberOfMessages = 1
    )

    responseMetaData = response['ResponseMetadata']
    statusCode = responseMetaData['HTTPStatusCode']

    if statusCode == 200: 
        print("Successuflly received a message form sqs")

        if 'Messages' in response:
            messages = response['Messages']
            
            print("Received {} messages from the sqs fifo".format(len(messages)))
        
            message = messages[0]
            messageId = message['MessageId']
            receiptHandle = message['ReceiptHandle']
            body = message['Body']

            print("Message={} with content={}".format(messageId, body))

            print("Now the message={} will be deleted".format(messageId))
            
            response = sqs.delete_message(
                QueueUrl = queue_url,
                ReceiptHandle = receiptHandle
            )
        else:
            print("Got no new messages.")
    else:
        print("Some error happened receiving a message form sqs")
    
    print("Now sleeping for 10 sec")
    
    time.sleep(10)
