provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config  = {
    bucket = "my-terraform-116"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
  }
}

output "project_name" {
  value = data.terraform_remote_state.global.outputs.company
}