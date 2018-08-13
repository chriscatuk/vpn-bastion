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
 - awscli
 - mtr
 - fping
 - apt-transport-https
 - ca-certificates
 - curl
 - software-properties-common
 - unzip
 - stress
 - make

runcmd:
 - echo '127.0.0.1 ${hostname}' | sudo tee -a /etc/hosts
 - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
 - add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
 - apt-get update
 - export DEBIAN_FRONTEND=noninteractive
 - apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
 - apt-get install docker-ce docker-compose -y
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
