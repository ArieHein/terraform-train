terraform {
  backend "s3" {
    bucket  = "value"
    key     = "terraform.tfstate"
    region  = "value"
    encrypt = true
    #dynamodb_table = "dynamo-tf-lock"
  }
}