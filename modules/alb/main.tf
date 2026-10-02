resource "aws_lb" "alb" {
  name               = "scalable-web-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.alb_sg_id
  ]

  subnets = [
    var.public_subnet_1a,
    var.private_subnet_1b
  ]

  tags = {
    Name        = "scalable-web-alb"
    Environment = "dev"
  }
}



resource "aws_lb_target_group" "alb_tg" {
  name        = "scalable-web-ec2-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }

  tags = {
    Name        = "scalable-web-ec2-tg"
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "sclable-web-ecs-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name       = "scalable-web-ecs-tg"
    Enviroment = "dev"
  }
}

resource "aws_lb_listener" "target_instance_ec2" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_listener_rule" "ecs_listener_rule" {
  listener_arn = aws_lb_listener.target_instance_ec2.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["/ecs/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}


