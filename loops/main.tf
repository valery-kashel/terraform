provider "aws" {
  region = "us-east-1"
}

variable "aws_users" {
  default = ["Valery", "Nick", "Alan", "Matt"]
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index )
}
