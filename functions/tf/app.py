import json
import boto3

def lambda_handler(event, context):
    
   print("Lambda function deployed via terraform 2...")
   return {
        'statusCode': 200,
        'body': json.dumps('Lambda function 2 successful')
   }
    