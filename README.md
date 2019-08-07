# vpn-bastion
Deployment of Bastion Instance accessible via VPN

VPC + VPN Provisioning
======================

This project creates (and delete) Linux Server Bastion in its own isolated VPC in AWS.
It adds a VPN Server compabible with iOS and MacOS native VPN Client provides access the Linux Server when you hit the road.
The output provides DNS Names, IP addresses and Credentials for the VPN Settings.
API Gateway provides a way to start this bastion only when needed.

Requirements
------------

- An SSH Public Key

Define all the Values in terraform.tfvars as shown in terraform.tfvars.example

If you don't want to use DNS Names with Route 53 but only IP, delete the following file:
- vpn-server-dnsname.tf

Otherwise you will need:
- A zone ID for your DNS Zone in Route 53

Optional to store terraform states in S3:
- backend.safe.tf copied from backend.safe.tf.example

Dependencies
------------

ipv6=false doesn't work yet in current version
Bug Issue 688:
 - https://github.com/terraform-providers/terraform-provider-aws/issues/688
 - https://github.com/terraform-providers/terraform-provider-aws/pull/2103


Usage Example
----------------

- Create terraform.tfvars from terraform.tfvars.example
- (optional) Create backend.safe.tf from backend.safe.tf.example
- terraform init
- (optional) terraform workspace new <workspace_name>
- terraform apply
- terraform destroy
- (optional) terraform workspace delete <workspace_name>

You can use inline vars to overide terraform.tfvars and deploy in a different region
- terraform workspace new paris
- terraform apply -var vpcname='VPN-Paris' -var region='eu-west-3' -var hostname='vpn-paris.domain.com'
- terraform destroy -var vpcname='VPN-Paris' -var region='eu-west-3' -var hostname='vpn-paris.domain.com'
- terraform workspace delete paris

VPN Clients setup on iOs or MacOS
----------------------------------
Follow this guide: https://libreswan.org/wiki/VPN_server_for_remote_clients_using_IKEv1_XAUTH_with_PSK

Enable Logs
-----------
https://github.com/hwdsl2/docker-ipsec-vpn-server#enable-libreswan-logs

To keep the Docker image small, Libreswan (IPsec) logs are not enabled by default. If you are an advanced user and wish to enable it for troubleshooting purposes, first start a Bash session in the running container:

docker exec -it ipsec-vpn-server env TERM=xterm bash -l
Then run the following commands:

```
apt-get update && apt-get -y install rsyslog
service rsyslog restart
service ipsec restart
sed -i '/pluto\.pid/a service rsyslog restart' /opt/src/run.sh
exit
```

When finished, you may check Libreswan logs with:

```
docker exec -it ipsec-vpn-server grep pluto /var/log/auth.log
docker exec -it ipsec-vpn-server tail -f pluto /var/log/auth.log
```

To check xl2tpd logs, run `docker logs ipsec-vpn-server`.

To Do
-----

- Enable IPv6 VPN (MacOS and iOS clients don't support IPv6)
- Switch to IKEv2: https://libreswan.org/wiki/VPN_server_for_remote_clients_using_IKEv2
