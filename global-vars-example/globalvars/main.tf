provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "my-terraform-116"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
  }
}

output "owner" {
  value = "Valery Kashel"
}

output "company" {
  value = "Test Company"
}

output "tags" {
  value = {
    project = "Pet project"
    country = "Poland"
  }
}