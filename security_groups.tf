# Security group for both ECS and EFS
resource "aws_security_group" "service_security_group" {
  name        = "ecs-group"
  description = "Group for ECS"
  vpc_id      = aws_default_vpc.default_vpc.id


  ingress {
    protocol    = "6"
    from_port   = 80
    to_port     = 8000
    cidr_blocks = [aws_default_vpc.default_vpc.cidr_block]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "service_security_group_efs" {
  name        = "efs-group"
  description = "Group for EFS"
  vpc_id      = aws_default_vpc.default_vpc.id


  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}
