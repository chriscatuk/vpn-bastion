# Final Output summarising VPN Credentials, IP Addresses and DNS Names

output "VPC Id" {
  value = "${aws_vpc.vpc.id} : ${var.vpcname} (${var.region})"
}

output "VPC link" {
  value = "https://${var.region}.console.aws.amazon.com/vpc/home?region=${var.region}#vpcs:filter=${aws_vpc.vpc.id}"
}

output "VPN Server Public IPv4" {
#  value = "${aws_instance.vpn_server.public_ip} (${aws_instance.vpn_server.id})"
  value = "${aws_eip.ip.public_ip} (${aws_instance.vpn_server.id})"
}

output "VPN Server Public IPv6" {
  value = ["${aws_instance.vpn_server.ipv6_addresses}"]
}

output "VPN Instance link" {
  value = "https://${var.region}.console.aws.amazon.com/ec2/v2/home?region=${var.region}#Instances:instanceId=${aws_instance.vpn_server.id};sort=desc:instanceId"
}

output "VPN Credentials" {
#  sensitive = true
  value = "Server: ${var.hostname} - PSK: ${random_string.PSK.result} - User: vpnuser / ${random_string.password.result} \n Internal: ${aws_route53_record.servername_ipv4_internal.name}"
}
