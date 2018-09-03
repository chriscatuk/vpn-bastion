# Final Output summarising VPN Credentials, IP Addresses and DNS Names

output "VPC Id" {
  value = "${aws_vpc.vpc.id} : ${var.vpcname} (${var.region})"
}

output "VPC link" {
  value = "https://${var.region}.console.aws.amazon.com/vpc/home?region=${var.region}#vpcs:filter=${aws_vpc.vpc.id}"
}

output "VPN Server Public IPv4" {
  value = "${module.vpn-server.public_ip} (${module.vpn-server.id})"
}

output "VPN Server Public IPv6" {
  value = "${module.vpn-server.ipv6_address}"
}

output "VPN Instance link" {
  value = "${module.vpn-server.aws_console_link}"
}

output "VPN Credentials" {
#  sensitive = true
  value = "Server: ${module.vpn-server.hostname} - PSK: ${module.vpn-server.vpn_psk} - User: ${module.vpn-server.vpn_user} / ${module.vpn-server.vpn_password} \n Internal: ${module.vpn-server.internal_hostname}"
}
