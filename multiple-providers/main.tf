provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "eu-central-1"
  alias = "EU"
}

resource "aws_instance" "server-us" {
  instance_type = "t2.micro"
  ami = "ami-07caf09b362be10b8"
  tags = {
    name = "US web server"
  }
}

resource "aws_instance" "server-eu" {
  provider = aws.EU
  instance_type = "t2.micro"
  ami = "ami-07caf09b362be10b8"
  tags = {
    name = "EU web server"
  }
}
