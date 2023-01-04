import json
import boto3
import datetime

client = boto3.client('events')


def lambda_handler(event, context):

    print("Trigger Cloudwatch Log function")

    # Setup Eventbridge Rule
    response = client.put_events(

        Entries=[
            {
                'Time': datetime.datetime.now(),
                'Source': 'Trigger Cloudwatch Log',
                'Resources': [],
                'DetailType':'Integration Layer Publisher POC',
                'Detail': json.dumps(event),
                'EventBusName':'arn:aws:events:us-east-1:231992682363:event-bus/default',
                'TraceHeader':'Integration Layer POC trace'
            }

        ]
    )

    return response
