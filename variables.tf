# Defines the Vars for the whole project
# You should defines your own values in terraform.tfvars (example in terraform.tfvars.example)

provider "aws" {  region = "${var.region}"  }
variable "region" {       default = "eu-west-2" }

#All resources will have this Name tag (VPC, SG, IGW, Subnets...)
variable "vpcname" {      default = "VPN-Test" }

#Subnet of the VPC (will be divided in 3 Availability Zones)
variable "cidr" {         default = "172.30.200.0/22" }

#This hostname will be setup in Linux and added to Route 53 DNS Names
#Should be FQDN, ex: vpn-test.domain.com
variable "hostname" {}
variable "route53_zoneID" {}

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
variable "deployment" {   default = "terraform" }
variable "environment" {  default = "test" }
variable "OWNER" {}
variable "ROLE" { default = "Bastion and VPN Server compatible with iOS and MacOS native VPN Clients"}
variable "AlwaysOn" {   default = "OFF" }  #Possible values are ON/OFF, ON="must not be stopped by cost saving scripts"

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

# AMI Image used for the Instance
# amzn2-ami-hvm-2.0.20180622.1-x86_64-gp2
# update list with ./scripts/get_amis.sh
variable "amis2" {
  type = "map"
  default = {
    "ap-south-1" = "ami-d783a9b8"
    "eu-west-3" = "ami-2cf54551"
    "eu-west-2" = "ami-b8b45ddf"
    "eu-west-1" = "ami-466768ac"
    "ap-northeast-2" = "ami-afd86dc1"
    "ap-northeast-1" = "ami-e99f4896"
    "sa-east-1" = "ami-6dca9001"
    "ca-central-1" = "ami-0ee86a6a"
    "ap-southeast-1" = "ami-05868579"
    "ap-southeast-2" = "ami-39f8215b"
    "eu-central-1" = "ami-7c4f7097"
    "us-east-1" = "ami-b70554c8"
    "us-east-2" = "ami-8c122be9"
    "us-west-1" = "ami-e0ba5c83"
    "us-west-2" = "ami-a9d09ed1"
  }
}

# ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180306
variable "ubuntu_amis" {
  type = "map"
  default = {
    "ap-south-1" = "ami-0189d76e"
    "eu-west-3" = "ami-0e55e373"
    "eu-west-2" = "ami-f4f21593"
    "eu-west-1" = "ami-f90a4880"
    "ap-northeast-2" = "ami-a414b9ca"
    "ap-northeast-1" = "ami-0d74386b"
    "sa-east-1" = "ami-423d772e"
    "ca-central-1" = "ami-ae55d2ca"
    "ap-southeast-1" = "ami-52d4802e"
    "ap-southeast-2" = "ami-d38a4ab1"
    "eu-central-1" = "ami-7c412f13"
    "us-east-1" = "ami-43a15f3e"
    "us-east-2" = "ami-916f59f4"
    "us-west-1" = "ami-925144f2"
    "us-west-2" = "ami-4e79ed36"
  }
}
