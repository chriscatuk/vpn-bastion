# terraform init
# terraform workspace new <workspace_name>
# terraform workspace select <workspace_name>
# terraform apply -var vpcname='VPN-Test' -var ipv6=true -var region='eu-west-3'

resource "aws_instance" "vpn_server" {
	ami           = "${lookup(var.ubuntu_amis, var.region)}"
	instance_type = "t2.micro"
  key_name = "${aws_key_pair.key.key_name}"
  subnet_id = "${aws_subnet.a.id}"
  associate_public_ip_address = true
  ipv6_address_count = 1
  vpc_security_group_ids = ["${aws_default_security_group.sg.id}"]
	tags {
    Name = "${var.vpcname}"
    environment = "${var.environment}"
    deployment = "${var.deployment}"
    hostname = "${var.hostname}"
    OWNER = "${var.OWNER}"
    ROLE = "${var.ROLE}"
    AlwaysOn = "${var.AlwaysOn}"
	}
  depends_on = ["aws_internet_gateway.gw"]
  lifecycle { create_before_destroy = true }

  user_data = "${data.template_file.user_data.rendered}"
}

data "template_file" "user_data" {
  template = "${file("templates/vpn-server-user_data.tpl")}"
  vars {
    hostname = "${var.hostname}"
    password = "${random_string.password.result}"
    psk = "${random_string.PSK.result}"
    keypubic = "${var.keypublic}"
    username = "${var.username}"
  }
}

########################
#      ELASTIC IP      #
########################
resource "aws_eip" "ip" {
  instance = "${aws_instance.vpn_server.id}"
  tags {
    Name = "${var.vpcname}"
    environment = "${var.environment}"
    deployment = "${var.deployment}"
    hostname = "${var.hostname}"
    OWNER = "${var.OWNER}"
    ROLE = "${var.ROLE}"
    AlwaysOn = "${var.AlwaysOn}"
  }
}

########################
#    VPN CREDENTIALS   #
########################
# Usage: ${random_string.password.result}
resource "random_string" "password" {
  length = 16
  special = false
}

resource "random_string" "PSK" {
  length = 16
  special = false
}
