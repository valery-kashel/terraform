variable "region" {
  default = "us-east-1"
}

variable "ec2_ami" {
  default = "ami-07caf09b362be10b8"
}

variable "ec2_instance" {
  default = "t2.micro"
}

variable "access_key_name" {
  default = "ec2 instance access"
}

variable "sg_ingress_ports" {
  default = ["80", "443", "22"]
}

variable "cidr_blocks" {
  default = ["0.0.0.0/0"]
}