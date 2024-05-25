provider "aws" {
  region = "us-east-1"
}

data "aws_security_group" "default_security_group" {
  tags = {
    Name = "default"
  }
}

resource "random_string" "random_password" {
  length           = 12
  special          = true
  override_special = "!$%#^&"
}

resource "aws_ssm_parameter" "rds_password" {
  name  = "/test_db/mysql"
  type  = "SecureString"
  value = random_string.random_password.result
}

data "aws_ssm_parameter" "my_db_password" {
  name       = "/test_db/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}

resource "aws_db_instance" "db_instance" {
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = "admin"
  db_name                = "test_db"
  password               = aws_ssm_parameter.rds_password.value
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  apply_immediately      = true
  vpc_security_group_ids = [data.aws_security_group.default_security_group.id]
}
