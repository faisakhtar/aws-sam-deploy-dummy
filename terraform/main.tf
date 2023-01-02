terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
backend "s3" {
        bucket = "faisterraformbuckets3" #This must exist already.
        key = "state.tfstate"
        region = "us-east-1"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}