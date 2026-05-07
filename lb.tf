resource "aws_lb_target_group" "ac2-tg" {
  name        = "ac2-tg"
  port        = 80
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc-ac2.id
}

resource "aws_alb_target_group_attachment" "ac2-tg-attachment" {
  target_group_arn = aws_lb_target_group.ac2-tg.arn
  target_id        = aws_instance.ac2-instance.id
  port             = 80
}

resource "aws_lb" "ac2-lb" {
  name               = "ac1-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ac2-lb-sg.id]
  subnets            = [aws_subnet.ac2-public-subnet-1.id, aws_subnet.ac2-public-subnet-2.id]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "ac1-listener" {
  load_balancer_arn = aws_lb.ac2-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ac2-tg.arn
  }
}


resource "aws_lb_listener_rule" "ac2-listener-rule" {
  listener_arn = aws_lb_listener.ac2-listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ac2-tg.arn

  }

  condition {
    path_pattern {
      values = ["/var/www/html/index.html"]
    }
  }
}
