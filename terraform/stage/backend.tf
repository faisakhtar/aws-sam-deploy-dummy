terraform {
  
backend "s3" {
        bucket = "faisterraformbuckets3" #This must exist already.
        key = "stage-state.tfstate"
        region = "us-east-1"
  }
}
#  lock {
#    backend "dynamodb" {
#      table = "my-tfstate-locks"
#      region = "us-west-2"
#    }
#  }
