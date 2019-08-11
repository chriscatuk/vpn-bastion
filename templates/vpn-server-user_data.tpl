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
 - jq
 - curl
 - stress
 - yum-cron

runcmd:
# Clone VPN-Bastion repo 1/2: Settings
 - git_repo=https://github.com/chriscatuk/vpn-bastion.git
 - git_dir=/opt/github/vpn-bastion
 - git_branch=master
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
# Docker
 - amazon-linux-extras install docker -y
 - sudo curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
 - sudo chmod +x /usr/bin/docker-compose
 - systemctl enable docker
 - systemctl start docker
# Clone VPN-Bastion repo 2/2: Clone & Install
 - git clone --depth=1 --branch $${git_branch} $${git_repo} $${git_dir}
 - modprobe af_key
 - cd $${git_dir}
# Uncomment to build locally instead of using Docker Hub latest version
# - docker build -t chriscat/ipsec-vpn-server $${docker_dir}
 - echo "      - VPN_PASSWORD=${password}" >> $${docker_dir}/docker-compose.yml
 - echo "      - VPN_IPSEC_PSK=${psk}" >> $${docker_dir}/docker-compose.yml
 - docker-compose -f $${docker_dir}/docker-compose.yml up -d
# Setup as SSH Jump Server
 - echo 'AcceptEnv AWS_*' >> /etc/ssh/sshd_config
# Ansible
# - amazon-linux-extras install ansible2 -y
# Terraform
# - wget https://releases.hashicorp.com/terraform/0.12.5/terraform_0.12.5_linux_amd64.zip -qP ~/
# - unzip ~/terraform_0.12.5_linux_amd64.zip -d /usr/local/bin/

power_state:
   delay: "now"
   mode: reboot
   message: Bye Bye
   timeout: 30
