
# data "aws_route53_zone" "primary" {
#   name         = "noelav.cloud"
#   private_zone = false  
# }

resource "aws_lb" "vpc1_alb" {
    
  name               = "vpc1-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.vpc1_sg.id]
  subnets         = [aws_subnet.sub1.id, aws_subnet.sub2.id]

}

resource "aws_lb_target_group" "vpc1_tg" {
  name     = "vpc1-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc1.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "lb_tg_attachment1" {
  target_group_arn = aws_lb_target_group.vpc1_tg.arn
  target_id        = aws_instance.vpc_ec21.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "lb_tg_attachment2" {
  target_group_arn = aws_lb_target_group.vpc1_tg.arn
  target_id        = aws_instance.vpc_ec22.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.vpc1_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.vpc1_tg.arn
    type             = "forward"
  }
}

output "loadbalancerdns" {
  value = aws_lb.vpc1_alb.dns_name
}


# resource "aws_route53_record" "alb" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = "noelav.cloud"
#   type    = "A"

#   alias {
#     name                   = aws_lb.vpc1_alb.dns_name
#     zone_id                = aws_lb.vpc1_alb.zone_id
#     evaluate_target_health = true
#   }
# }



output "alb_dns"{

    value= aws_lb.vpc1_alb.dns_name

}
