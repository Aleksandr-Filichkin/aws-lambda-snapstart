variable "aws_access_key" {
  default = ""
}
variable "aws_secret_key" {
  default = ""
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
