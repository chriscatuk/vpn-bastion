# Latest AMI for Amazon Linux 2 in this region
# 31/07/2018: amzn2-ami-hvm-2.0.20180622.1-x86_64-gp2

data "aws_ami" "ami_amzn2" {
  most_recent      = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}