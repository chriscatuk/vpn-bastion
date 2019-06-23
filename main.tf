module "vpn-server" {
  source = "./modules/gp-instance"
  
  project_name = "${var.vpcname}"
  subnet_id = "${aws_subnet.a.id}"
  sg_id = "${aws_default_security_group.sg.id}"
  region = "${var.region}"
  hostname = "${var.hostname}"
  route53_zoneID = "${var.route53_zoneID}"
  instance_type = "${var.instance_type}"
  template_path = "${path.module}/${var.template_path}"
  template_vars = {
    hostname = "${var.hostname}"
    password = "${random_string.password.result}"
    psk = "${random_string.PSK.result}"
    keypubic = "${var.keypublic}"
    username = "${var.username}"
  }

  ipv6 = "${var.ipv6}"
  username = "${var.username}"

  keyname = "${var.keyname}"
  keypublic = "${var.keypublic}"

  tags = {
    Name = "${var.vpcname}"
    environment = "${var.environment}"
    deployment = "${var.deployment}"
    OWNER = "${var.OWNER}"
    ROLE = "${var.ROLE}"
    AlwaysOn = "${var.AlwaysOn}"
  }

  fw_all_cidr_ipv4 = "${var.fw_all_cidr_ipv4}"
  fw_all_cidr_ipv6 = "${var.fw_all_cidr_ipv6}"
  fw_ssh_cidr_ipv4 = "${var.fw_ssh_cidr_ipv4}"
  fw_ssh_cidr_ipv6 = "${var.fw_ssh_cidr_ipv6}"
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