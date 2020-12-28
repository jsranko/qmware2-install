#!/bin/bash

GITHUB_KEY=~/.ssh/github_id_rsa
SSH_CONFIG=~/.ssh/config

cd ~/.ssh

# create .ssh if not exist
ssh -T git@github.com || true

# create private key for githubt (deploy key)
if ! [ -f "${GITHUB_KEY}" ]; then
   ssh-keygen -t rsa -b 4096 -C "info@qm-ware.de" -f ${GITHUB_KEY} -q -P ""

   # register key into agent
   sudo chmod 400 ${GITHUB_KEY}
   eval "$(ssh-agent -s)"
   ssh-add ${GITHUB_KEY}
fi

if ! [ -f "${SSH_CONFIG}" ]; then
   touch ${SSH_CONFIG} && chmod 600 ${SSH_CONFIG} 
   echo -e "HostName github.com\n  IdentityFile ${GITHUB_KEY}\n  PreferredAuthentications publickey\n  User git\n  IdentitiesOnly yes" > ${SSH_CONFIG}
fi

echo "Save this key to qmware2 github repository"
cat ${GITHUB_KEY}.pub

while true; do
    read -p "Has GitHub deploy key been registered?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

cd

# Install docker
if ! [ -f "/usr/bin/docker" ]; then
   sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo && sudo dnf install docker-ce --nobest -y
   sudo iptables -t filter -F
   sudo iptables -t filter -X
fi

if ! [ -f "/usr/local/bin/docker-compose" ]; then
   sudo dnf install curl -y
   sudo curl -L https://github.com/docker/compose/releases/download/1.25.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

fi

mkdir db_data
