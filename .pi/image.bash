#!/bin/bash

# This install script runs inside the chroot of your image builder.
# After it runs, a second shell session installs nodejs with nvm

# Connect to the internet by configuring DNS
mv /etc/resolv.conf /etc/resolv.conf.bk
echo 'nameserver 8.8.8.8' > /etc/resolv.conf
echo 'nameserver 1.1.1.1' >> /etc/resolv.conf

# Update packages and install Zerotier
apt update
apt install -y curl wget jq apt-transport-https gnupg gnupg-agent software-properties-common build-essential
wget http://download.zerotier.com/debian/buster/pool/main/z/zerotier-one/zerotier-one_1.4.6_arm64.deb
dpkg -i zerotier-one_1.4.6_arm64.deb
apt install -y

# Install Go
wget https://golang.org/dl/go1.15.2.linux-arm64.tar.gz
tar -C /usr/local -xzf go1.15.2.linux-arm64.tar.gz 1> /dev/null
echo "export PATH=$PATH:/usr/local/go/bin" >> /root/.profile
echo "export PATH=$PATH:/usr/local/go/bin" >> /home/ubuntu/.profile
. /root/.profile
go version


# Set up Nodejs without NVM
wget https://nodejs.org/dist/v12.18.4/node-v12.18.4-linux-arm64.tar.xz
sudo mkdir -p /usr/local/lib/nodejs
sudo tar -xJvf node-v12.18.4-linux-arm64.tar.xz -C /usr/local/lib/nodejs 1> /dev/null
echo "export PATH=/usr/local/lib/nodejs/node-v12.18.4-linux-arm64/bin:$PATH" >> /root/.profile
echo "export PATH=/usr/local/lib/nodejs/node-v12.18.4-linux-arm64/bin:$PATH" >> /home/ubuntu/.profile
. /root/.profile
node -v
npm version
npx -v


# Set Up Starport
cd /starport
cd starport
make
cp build/starport /usr/bin
chmod +x /usr/bin/starport
