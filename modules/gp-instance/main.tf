resource "aws_instance" "vpn_server" {
  ami           = "${data.aws_ami.ami_amzn2.id}"
	instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.key.key_name}"
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true
  ipv6_address_count = 1
  vpc_security_group_ids = ["${var.sg_id}"]
	tags = "${var.tags}"
  lifecycle { create_before_destroy = true }
  credit_specification {
    cpu_credits = "standard"
  }

  user_data = "${data.template_file.user_data.rendered}"
}

data "template_file" "user_data" {
  template = "${file("${local.template_path}")}"
  vars = "${local.template_vars}"
}

########################
#          AMI         #
########################

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
    values = ["amzn2-ami-hvm-*-x86_64-gp2-dotnetcore-2018.12.12"]
  }
}

# ########################
# #    EBS Persistant    #
# ########################
# resource "aws_ebs_volume" "persistant" {
#   availability_zone = "${aws_subnet.a.availability_zone}"
#   size = 2
#   type = "gp2"
# 	tags = "${var.tags}"
# }

# resource "aws_volume_attachment" "ebs_att" {
#   device_name = "/dev/sdh"
#   volume_id   = "${aws_ebs_volume.persistant.id}"
#   instance_id = "${aws_instance.vpn_server.id}"
# }


########################
#      ELASTIC IP      #
########################
resource "aws_eip" "ip" {
  instance = "${aws_instance.vpn_server.id}"
	tags = "${var.tags}"
}

# Define the Key Pair you will add in AWS
# It must not exist before running the script

########################
#       Key Pair       #
########################
resource "aws_key_pair" "key" {
   key_name   = "${var.keyname}"
   public_key = "${var.keypublic}"
}


########################
#       DNS NAME       #
########################

# You can remove this file if you don't want to use DNS Names

resource "aws_route53_record" "servername_ipv4" {
  zone_id = "${var.route53_zoneID}"
  name    = "${var.hostname}."
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.ip.public_ip}"]
}

resource "aws_route53_record" "servername_ipv4_internal" {
  zone_id = "${var.route53_zoneID}"
  name    = "internal-${var.hostname}."
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.vpn_server.private_ip}"]
}

resource "aws_route53_record" "servername_ipv6" {
  zone_id = "${var.route53_zoneID}"
  name    = "${var.hostname}."
  type    = "AAAA"
  ttl     = "300"
  records = ["${aws_instance.vpn_server.ipv6_addresses}"]
}
