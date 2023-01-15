terraform {
  
backend "s3" {
        bucket = "faisterraformbuckets3" #This must exist already.
        key = "fs23_stage.tfstate"
        region = "us-east-1"
  }
}