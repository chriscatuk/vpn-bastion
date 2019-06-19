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
 - jq
 - curl
 - stress
 - yum-cron
 - python2-pip

runcmd:
# Clone VPN-Bastion repo 1/2: Settings
 - git_repo=https://github.com/chriscatuk/vpn-bastion.git
 - git_dir=/opt/github/vpn-bastion
 - docker_dir=$${git_dir}/docker-ipsec-vpn-server
# Hostname
 - echo '127.0.0.1 ${hostname}' | sudo tee -a /etc/hosts
 - [ sed, -i, -e, "s/HOSTNAME=.*/HOSTNAME=${hostname}/", /etc/sysconfig/network ]
# Yum settings for security updates
 - yum -y update
 - systemctl enable yum-cron
 - sed -i -e 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron.conf
 - sed -i -e 's/update_cmd = default/update_cmd = security/g' /etc/yum/yum-cron-hourly.conf
 - sed -i -e 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron-hourly.conf
 - sed -i -e 's/update_messages = no/update_messages = yes/g' /etc/yum/yum-cron-hourly.conf
 - sed -i -e 's/download_updates = no/download_updates = yes/g' /etc/yum/yum-cron-hourly.conf
 - sed -i -e 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron-hourly.conf
 - systemctl start yum-cron
# Docker and Ansible
 - amazon-linux-extras install docker ansible2 -y
 - sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
 - sudo chmod +x /usr/bin/docker-compose
 - chkconfig docker on
 - systemctl start docker
# Clone VPN-Bastion repo 2/2: Clone & Install
 - git clone --depth=1 $${git_repo} $${git_dir}
 - modprobe af_key
 - docker build -t ipsec-vpn-server-private $${docker_dir}
 - echo "      - VPN_PASSWORD=${password}" >> $${docker_dir}/docker-compose.yml
 - echo "      - VPN_IPSEC_PSK=${psk}" >> $${docker_dir}/docker-compose.yml
 - docker-compose -f $${docker_dir}/docker-compose.yml up -d
# Setup as SSH Jump Server
 - echo 'AcceptEnv AWS_*' >> /etc/ssh/sshd_config
# Terraform
 - wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip -qP ~/
 - unzip ~/terraform_0.11.8_linux_amd64.zip -d /usr/local/bin/
# aws cli auth by Google
 - pip3 install aws-google-auth

power_state:
   delay: "now"
   mode: reboot
   message: Bye Bye
   timeout: 30
