import json
import boto3

def lambda_handler(event, context):
    
   print("Lambda function deployed via terraform abc 1...")
   return {
        'statusCode': 200,
        'body': json.dumps('Lambda function abc 1 successful')
   }
    