terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.48.0"
    }
  }
backend "s3" {
        bucket = "faisterraformbuckets3" #This must exist already.
        key = "state.tfstate"
        region = "us-east-1"
  }
#  lock {
#    backend "dynamodb" {
#      table = "my-tfstate-locks"
#      region = "us-west-2"
#    }
#  }


  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}