module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  count = var.instances

  name = "web${count.index + 1}"

  ami                    = "ami-096800910c1b781ba"
  instance_type          = "t2.nano"
  monitoring             = true
  vpc_security_group_ids = [resource.aws_security_group.ec2_ssh.id]
  subnet_id              = element(module.vpc.private_subnets, count.index)

  user_data = <<-EOF
  #!/bin/bash
  #Installing Docker
  sudo apt-get remove docker docker-engine docker.io
  sudo apt-get update
  sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
  sudo apt-get update
  sudo apt-get install docker-ce -y
  sudo usermod -a -G docker $USER
  sudo systemctl enable docker
  sudo systemctl restart docker
  mkdir ~/app && echo "Hello World" > ~/app/index.html
  sudo docker run --name docker-nginx -v ~/app/:/usr/share/nginx/html/ -p 80:80 nginx:latest
  EOF

  key_name = "ssh-key"

  tags = merge(var.tags, {
    Resource  = "ec2"
  })
}

###Add your key if required###
# resource "aws_key_pair" "ssh-key" {
#   key_name   = "ssh-key"
#   public_key = "ssh-ed25519 ..."
# }
