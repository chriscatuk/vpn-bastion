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

runcmd:
 - echo '127.0.0.1 ${hostname}' | sudo tee -a /etc/hosts
 - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
 - add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
 - apt-get update
 - apt-get dist-upgrade -y --allow-change-held-packages -qq
 - apt-get install docker-ce -y
 - docker pull hwdsl2/ipsec-vpn-server
 - modprobe af_key
 - docker run --name ipsec-vpn-server --restart=always -p 500:500/udp -p 4500:4500/udp -v /lib/modules:/lib/modules:ro -d --privileged hwdsl2/ipsec-vpn-server
 - docker cp ipsec-vpn-server:/opt/src/vpn-gen.env /home/ubuntu/

power_state:
   delay: "now"
   mode: reboot
   message: Bye Bye
   timeout: 30
