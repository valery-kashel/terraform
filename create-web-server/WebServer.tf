provider "aws" {
  region = var.region
}

resource "aws_instance" "my_webserver" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  key_name               = var.access_key_name
  user_data              = templatefile("user_data.sh.tpl", {
    owner = "Valery", made_by = ["Valery", "Nicolas", "Peter", "Matt"]
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My first Security Group"

  dynamic "ingress" {
    for_each = var.sg_ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks
  }
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
}
