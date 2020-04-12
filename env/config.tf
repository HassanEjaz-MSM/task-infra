provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    #bucket = "bucket"
    key    = "test/env/env.tfstate"
    region = "us-east-1"
    #dynamodb_table = "terraform-state-lock"
  }
}