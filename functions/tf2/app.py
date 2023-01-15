import json
import boto3
import ptvsd
ssmclient = boto3.client('ssm')


print("Enabled Attachement")
print(ptvsd.is_attached())
if (ptvsd.is_attached() == True):
    print("Debugger attached")
else:
    ptvsd.enable_attach(address=('0.0.0.0', 3001), redirect_output=True)
    ptvsd.wait_for_attach()

def lambda_handler(event, context):
    
   

   print("Lambda function deployed via terraform abc 7...")
   parameter = ssmclient.get_parameter(Name='/iconicsDBName/dev', WithDecryption=True)

   return {
        'statusCode': 200,
        'body': json.dumps('Lambda function abc 4 successful with ' + parameter['Parameter']['Value'])
   }
    