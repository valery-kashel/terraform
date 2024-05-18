provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-07caf09b362be10b8"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  key_name               = "ec2 instance access"

  tags = {
    Name = "Web Server"
  }

  depends_on = [aws_instance.my_kafka, aws_instance.my_db]
}


resource "aws_instance" "my_db" {
  ami                    = "ami-07caf09b362be10b8"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  key_name               = "ec2 instance access"

  tags = {
    Name = "DB Server"
  }
}

resource "aws_instance" "my_kafka" {
  ami                    = "ami-07caf09b362be10b8"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  key_name               = "ec2 instance access"

  tags = {
    Name = "Kafka Server"
  }

  depends_on = [aws_instance.my_db]
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My first Security Group"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
