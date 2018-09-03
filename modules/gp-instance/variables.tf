# Defines the Vars for the whole project
# You should defines your own values in terraform.tfvars (example in terraform.tfvars.example)

#All resources will have this Name tag (VPC, SG, IGW, Subnets...)
variable "project_name" {      default = "VPN-Bastion" }

variable "region" {}
variable "subnet_id" {}
variable "sg_id" {}

#This hostname will be setup in Linux and added to Route 53 DNS Names
#Should be FQDN, ex: vpn-test.domain.com
variable "hostname" {}
variable "route53_zoneID" {}
variable "instance_type"  { default = "t2.micro" }
variable "template_path" { default = "" }

# Enable IPv6 support, in Dual Stack mode
# Bug Issue 688: https://github.com/terraform-providers/terraform-provider-aws/issues/688
# Soon ipv6 false possible.
# https://github.com/terraform-providers/terraform-provider-aws/pull/2103
variable "ipv6" {         default = true }

# User with SSH and Sudo access.
variable "username" {}

#SSH Key Pair
variable "keyname" {} # keyname must not already exist before running the script
variable "keypublic" {} # keypublic line will be added to ~/.ssh/authorized_keys

# Tags of all resources
variable "tags" { type = "map" }  #Possible values are ON/OFF, ON="must not be stopped by cost saving scripts"

# CIDRs allowed for VPN traffic
variable "fw_all_cidr_ipv4" {
  type = "list"
  default = ["0.0.0.0/0"]
}
variable "fw_all_cidr_ipv6" {
  type = "list"
  default = ["::/0"]
}

# CIDRs allowed for SSH
variable "fw_ssh_cidr_ipv4" {
  type = "list"
  default = ["0.0.0.0/0"]
}
variable "fw_ssh_cidr_ipv6" {
  type = "list"
  default = ["::/0"]
}
