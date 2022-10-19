resource "aws_security_group" "ec2_ssh" {
  name        = "ec2_ssh"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port        = "22"
    to_port          = "22"
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"] 
    }
}

data "aws_ip_ranges" "cloudfront" {
  services = ["CLOUDFRONT"]
}

resource "aws_security_group" "alb_cloudfront_ipv4_sg" {
  name        = "alb_cloudfront_ipv4"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port        = "80"
    to_port          = "80"
    protocol         = "tcp"
    cidr_blocks      = data.aws_ip_ranges.cloudfront_ec2.cidr_blocks
  }

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"] 
    }
}

resource "aws_security_group" "alb_cloudfront_ipv6_sg" {
  name        = "alb_cloudfront_ipv6"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port        = "80"
    to_port          = "80"
    protocol         = "tcp"
    ipv6_cidr_blocks = data.aws_ip_ranges.cloudfront.ipv6_cidr_blocks
  }

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"] 
    }
}

data "aws_ip_ranges" "ec2" {
  services = ["ec2"]
}

resource "aws_security_group" "ec2_ipv6" {
  name        = "ec2_ipv6"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port        = "80"
    to_port          = "80"
    protocol         = "tcp"
    ipv6_cidr_blocks = data.aws_ip_ranges.cloudfront.ipv6_cidr_blocks
  }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"] 
    }
}

resource "aws_security_group" "ec2_ipv4" {
  name        = "ec2_ipv4"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port        = "80"
    to_port          = "80"
    protocol         = "tcp"
    cidr_blocks      = data.aws_ip_ranges.cloudfront.cidr_blocks
  }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"] 
    }
}
