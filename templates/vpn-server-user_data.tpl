#cloud-config
repo_update: true
repo_upgrade: all
hostname: ${hostname}

users:
  - name: ${username}
    groups: [ wheel ]
    sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
    shell: /bin/bash
    ssh-authorized-keys:
      - ${keypubic}

packages:
 - amazon-efs-utils
 - mtr
 - mailx
 - git
 - python3
 - docker
 - curl
 - stress
 - yum-cron

runcmd:
 - echo '127.0.0.1 ${hostname}' | sudo tee -a /etc/hosts
 - [ sed, -i, -e, "s/HOSTNAME=.*/HOSTNAME=${hostname}/", /etc/sysconfig/network ]
 - yum -y update
 - systemctl enable yum-cron
 - sed -i -e 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron.conf
 - sed -i -e 's/update_cmd = default/update_cmd = security/g' /etc/yum/yum-cron-hourly.conf
 - sed -i -e 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron-hourly.conf
 - sed -i -e 's/update_messages = no/update_messages = yes/g' /etc/yum/yum-cron-hourly.conf
 - sed -i -e 's/download_updates = no/download_updates = yes/g' /etc/yum/yum-cron-hourly.conf
 - sed -i -e 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron-hourly.conf
 - systemctl start yum-cron
 - sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
 - sudo chmod +x /usr/bin/docker-compose
 - chkconfig docker on
 - systemctl start docker
 - git clone --depth=1 https://github.com/chriscatuk/vpn-bastion.git /opt/github/vpn-bastion
 - modprobe af_key
 - docker build -t ipsec-vpn-server-private /opt/github/vpn-bastion/docker-ipsec-vpn-server
 - echo "      - VPN_PASSWORD=${password}" >> /opt/github/vpn-bastion/docker-ipsec-vpn-server/docker-compose.yml
 - echo "      - VPN_IPSEC_PSK=${psk}" >> /opt/github/vpn-bastion/docker-ipsec-vpn-server/docker-compose.yml
 - docker-compose -f /opt/github/vpn-bastion/docker-ipsec-vpn-server/docker-compose.yml up -d
 - echo 'AcceptEnv AWS_*' >> /etc/ssh/sshd_config
 - wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip -P ~/
 - unzip ~/terraform_0.11.7_linux_amd64.zip -d /usr/local/bin/

power_state:
   delay: "now"
   mode: reboot
   message: Bye Bye
   timeout: 30
