#!/bin/sh
#Update and upgrade ubuntu
echo "Updating ubuntu..."
sudo apt-get update
sudo apt-get upgrade -y

echo "Removing old docker packages..."
sudo apt-get remove docker docker-engine docker.io containerd runc -y

echo "Install docker-ce pre-reqs"
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y

echo "Getting doocker-ce..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "Updating ubuntu again..."
sudo apt-get update

echo "Installing docker-ce, docker-ce-cli and containerd.io..."
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker

echo "Installing docker-compose..."
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


echo "Installing nvidia docker..."
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
