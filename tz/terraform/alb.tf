module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "tz-alb"

  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [resource.aws_security_group.alb_cloudfront_ipv4_sg.id, resource.aws_security_group.alb_cloudfront_ipv6_sg.id]


  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  tags = merge(var.tags, {
    Resource  = "alb"
  })
}

#Instance Attachment
resource "aws_alb_target_group_attachment" "target_group_tz" {
  count            = var.instances
  target_group_arn = module.alb.target_group_arns[0]
  target_id        = module.ec2_instance[count.index].id
  port             = 80
}
