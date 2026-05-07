resource "aws_security_group" "ac2-sg" {
  description = "Security Group de la instancia"
  name   = "terraform-ac2-sg"
  vpc_id = aws_vpc.vpc-ac2.id

  dynamic "ingress" {
    for_each = var.ingress_rules

    content {
      description = ingress.key
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
    Name = "terraform-ac1-sg"
  }
}

resource "aws_security_group" "ac2-lb-sg" {
  description = "Security Group del load balancer"
  name   = "terraform-ac2-lb-sg"
  vpc_id = aws_vpc.vpc-ac2.id
  ingress {
    from_port = 80
    to_port   = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "terraform-ac2-lb-sg"
  }
}
