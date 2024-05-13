provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-07caf09b362be10b8"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  key_name               = "ec2 instance access"
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
echo "<h2>Hello from my web server<h2>" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF

}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My first Security Group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
