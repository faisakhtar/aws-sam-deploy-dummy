import json
import boto3
import datetime

dynamo_client = boto3.client('dynamodb')

def lambda_handler(event, context):

    #write_to_db()
    current_state = get_current_state()["data"]
    
    try:
        state_field = current_state["state"]
    except KeyError:
        state_field = ""
    
    try:
        file_reference_field = current_state["file_reference"]
    except KeyError:
        file_reference_field = ""

    try:
        last_run_action_field = current_state["last_run_action"]
    except KeyError:
        last_run_action_field = ""

    print(state_field)
    print(file_reference_field)
    print(last_run_action_field)

    if (state_field == "running"):
        print("Already running, so exit")
    elif (state_field == "success" or state_field == "failed" or state_field == ""):
        print("Restart job by triggering sftp poll event.")
    elif (state_field == "hold"):
        print("Determine last run action and pass in file reference.")

    return {"status": "success"}
    

def get_current_state():
    table_name = "state"
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table(table_name)
    
    response = table.scan(Limit=1)
    item = response["Items"][0]
    print(item)
    
    return {"data": item}
    
def write_to_db():
    # Write to DynamoDB Table.
    table_name = "state"
    item = {
        "state": {"S": "running"},
        "file_reference": {"S": "nofile"},
        "last_run_action": {"S": "process_data"}
    }

    dynamo_client.put_item(TableName=table_name, Item=item)
    
    return {"status": "success"}
    

