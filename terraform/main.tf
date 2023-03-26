provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-alex-test1"
    key            = "test/web-flux-fargate.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-locking"
  }
}
