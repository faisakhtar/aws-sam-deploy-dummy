resource "aws_dynamodb_table" "journals_worklist_dynamodb" {
  name         = "worklist"
  hash_key     = "file_reference"
  billing_mode = "PAY_PER_REQUEST"
  range_key    = "order"

  attribute {
    name = "file_reference"
    type = "S"
  }

  attribute {
    name = "order"
    type = "N"
  }
  
}