import json
import boto3
import datetime

dynamo_client = boto3.client('dynamodb')
eventbridge_client = boto3.client("events")

s3_client =boto3.resource('s3')

ses = boto3.client('ses')


s3_bucket_name='fa-dlq-failed-event-messages'
emailfile='sampleemails.txt'

def lambda_handler(event, context):
    
    worklist_response = dynamo_client.scan(TableName="worklist", Limit=1)
    worklist_item = worklist_response["Items"]
    
    if (len(worklist_item) == 0):
        print("No more items to process!")
        print("Send a success event message")
        send_email()
        return
    
    worklist_item = worklist_item[0]
    
    current_file_reference = worklist_item["file_reference"]["S"]
    current_order = int(worklist_item["order"]["N"])
    
    if (current_order == 1):
        print("Currently processing 1")
    else:
        print("Currently processing " + str(current_order))
        
    
    # Delete the processed record.
    dynamodb_resource = boto3.resource('dynamodb')
    dynamo_table = dynamodb_resource.Table('worklist')
    dynamo_table.delete_item(Key={'file_reference': current_file_reference, "order" : current_order})
    
    
    # Trigger the process data event to move onto the next file to proces.
    eventbridge_response = eventbridge_client.put_events(
            Entries=[
                {
                    "Time": str(datetime.datetime.now()),
                    "Source": "main",
                    "Resources": [],
                    "DetailType": "main",
                    "Detail": json.dumps(
                        {
                            "reference": "process_data",
                            "file_reference": "not_required",
                        }
                    ),
                }
            ]
        )
    print("eventbridge_response: ", eventbridge_response)
    
    
        
    #thefile = s3_client.Object(s3_bucket_name,emailfile)
    #email_data=thefile.get()['Body'].read()
    #print(email_data)
   
    return {
        'statusCode': 200,
        'body': json.dumps('Lambda function abc 4 successful with ')
   }
    

def send_email():
    ses_response = ses.send_templated_email(
        Source='',
        Destination={
            'ToAddresses': [
                '',
            ],
        },
        Template='basic_email_template',
        TemplateData='{\"name\":\"De Ak\"}'
    )

    print(ses_response)
    return True