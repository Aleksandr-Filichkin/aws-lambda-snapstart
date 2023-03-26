resource "aws_dynamodb_table" "global" {
  name         = var.db-name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"


  attribute {
    name = "id"
    type = "S"
  }

}