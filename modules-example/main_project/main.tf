provider "aws" {
  region = "us-east-1"
}

module "vpc-default" {
  source = "../modules/aws_network"
}

module "vpc-dev" {
  source              = "../modules/aws_network"
  env                 = "dev"
  vpc_cidr            = "10.1.0.0/16"
  public_subnet_cidrs = [
    "10.1.1.0/24",
    "10.1.2.0/24",
    "10.1.3.0/24"
  ]
  private_subnet_cidrs = []
}


module "vpc-prod" {
  source              = "../modules/aws_network"
  env                 = "prod"
  vpc_cidr            = "10.2.0.0/16"
  public_subnet_cidrs = [
    "10.2.1.0/24",
    "10.2.2.0/24",
    "10.2.3.0/24"
  ]
  private_subnet_cidrs = [
    "10.2.11.0/24",
    "10.2.22.0/24",
    "10.2.33.0/24"
  ]
}

output "prod_vpc_ip" {
  value = module.vpc-prod.vpc_id
}
