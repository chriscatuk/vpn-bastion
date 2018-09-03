output "private_ip" {
  value = "${aws_instance.vpn_server.private_ip}"
}
output "public_ip" {
  value = "${aws_eip.ip.public_ip}"
}

output "id" {
  value = "${aws_instance.vpn_server.id}"
}

output "ipv6_address" {
  value = "${aws_instance.vpn_server.ipv6_addresses}"
}

output "aws_console_link" {
  value = "https://${var.region}.console.aws.amazon.com/ec2/v2/home?region=${var.region}#Instances:instanceId=${aws_instance.vpn_server.id};sort=desc:instanceId"
}

output "hostname" {
  value = "${var.hostname}"
}
output "internal_hostname" {
  value = "internal-${var.hostname}"
}
output "vpn_user" {
  sensitive = true
  value = "vpnuser"
}
output "vpn_psk" {
  sensitive = true
  value = "${random_string.PSK.result}"
}
output "vpn_password" {
  sensitive = true
  value = "${random_string.password.result}"
}