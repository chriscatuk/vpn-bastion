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

# resource "aws_route53_record" "servername_ipv6" {
#   zone_id = "${var.route53_zoneID}"
#   name    = "${var.hostname}."
#   type    = "AAAA"
#   ttl     = "300"
#   records = ["${aws_instance.vpn_server.ipv6_addresses}"]
# }
