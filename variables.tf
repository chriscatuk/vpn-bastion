# Defines the Vars for the whole project
# You should defines your own values in terraform.tfvars (example in terraform.tfvars.example)

variable "region" {
  default = "eu-west-2"
}

#All resources will have this Name tag (VPC, SG, IGW, Subnets...)
variable "vpcname" {
  default = "VPN-Test"
}

#Subnet of the VPC (will be divided in 3 Availability Zones)
variable "cidr" {
  default = "172.30.200.0/22"
}

#This hostname will be setup in Linux and added to Route 53 DNS Names
#Should be FQDN, ex: vpn-test.domain.com
variable "hostname" {
}

variable "route53_zoneID" {
}

variable "instance_type" {
  default = "t2.micro"
}

# define with relative path, ${path.module} will be added
# template_path = "templates/vpn-server-user_data.tpl"
variable "template_path" {
  default = "templates/vpn-server-user_data.tpl"
}

# Enable IPv6 support, in Dual Stack mode
# Bug Issue 688: https://github.com/terraform-providers/terraform-provider-aws/issues/688
# Soon ipv6 false possible.
# https://github.com/terraform-providers/terraform-provider-aws/pull/2103
variable "ipv6" {
  default = true
}

# User with SSH and Sudo access.
variable "username" {
}

#SSH Key Pair
variable "keyname" { # keyname must not already exist before running the script
}

variable "keypublic" { # keypublic line will be added to ~/.ssh/authorized_keys
}

# Tags of all resources
variable "deployment" {
  default = "terraform"
}

variable "environment" {
  default = "test"
}

variable "OWNER" {
}

variable "ROLE" {
  default = "Bastion and VPN Server compatible with iOS and MacOS native VPN Clients"
}

variable "AlwaysOn" { #Possible values are ON/OFF, ON="must not be stopped by cost saving scripts"
  default = "OFF"
}

# CIDRs allowed for VPN traffic
variable "fw_all_cidr_ipv4" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "fw_all_cidr_ipv6" {
  type    = list(string)
  default = ["::/0"]
}

# CIDRs allowed for SSH
variable "fw_ssh_cidr_ipv4" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "fw_ssh_cidr_ipv6" {
  type    = list(string)
  default = ["::/0"]
}

