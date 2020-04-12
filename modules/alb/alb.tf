resource "aws_alb" "alb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets
}

resource "aws_alb_target_group" "alb_tg" {
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn  = aws_alb.alb.arn
  port               = 8080
  protocol           = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.alb_tg.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "alb_route" {
  listener_arn = aws_alb_listener.alb_listener.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_tg.arn
  }
    condition {
    field  = "path-pattern"
    values = ["/hello*"]
  }
}