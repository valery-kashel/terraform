provider "aws" {}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current_identity" {}
data "aws_region" "current_region" {}

data "aws_vpc" "prod_vpc" {
  tags = {
    Name = "prod"
  }
}

output "prod_vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}

output "prod_vpc_cidr" {
  value = data.aws_vpc.prod_vpc.cidr_block
}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names[1]
}

output "data_aws_called_identity" {
  value = data.aws_caller_identity.current_identity.account_id
}

output "data_aws_current_region_name" {
  value = data.aws_region.current_region.name
}

output "data_aws_current_region_description" {
  value = data.aws_region.current_region.description
}
