variable "aws_access_key" {
}
variable "aws_secret_key" {
}

variable "region" {
  type    = string
  default = "eu-west-1"
}
variable "db-name" {
  description = "book"
}

variable "function-name" {
  description = "the name of Lambda function"
}
