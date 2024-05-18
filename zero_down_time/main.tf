provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "my_webserver_sg" {
  name = "Dynamic Security Group"

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

  tags = {
    Name = "Dynamic security group"
  }
}

resource "aws_launch_configuration" "web" {
  name_prefix     = "Web-LC-"
  image_id        = "ami-07caf09b362be10b8"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.my_webserver_sg.id]
  user_data       = file("user_data.sh")
  key_name        = "ec2 instance access"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_autoscaler" {
  name                 = "Web Autoscaler"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 2
  max_size             = 4
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.web_elb.name]
  vpc_zone_identifier  = [
    aws_default_subnet.default_subnet_1.id,
    aws_default_subnet.default_subnet_2.id
  ]
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "Web Server ASG"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web_elb" {
  name               = "Web-ELB"
  availability_zones = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1]
  ]

  security_groups = [aws_security_group.my_webserver_sg.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 5
    target              = "HTTP:80/"
    timeout             = 3
    unhealthy_threshold = 10
  }

  tags = {
    Name = "Web Server ELB"
  }
}

resource "aws_default_subnet" "default_subnet_1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_subnet_2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

output "web_loadbalancer_url" {
  value = aws_elb.web_elb.dns_name
}
