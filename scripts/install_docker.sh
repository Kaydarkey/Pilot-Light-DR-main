#!/bin/bash

# Remove any old Docker versions
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
    sudo apt-get remove -y $pkg 
done

# System update & install dependencies
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg unzip jq

# install aws cli
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install

# Setup Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repo to apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again
sudo apt update -y

# Install Docker components (Compose V2 included)
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker and enable it on boot
sudo systemctl start docker
sudo systemctl enable docker

# (Optional) Install Compose V2 manually as CLI plugin — only needed if not using the plugin package
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

SECRET_NAME=$(aws secretsmanager list-secrets --query "SecretList[?Description=='RDS instance credentials'].Name" --output text)
DB_SECRETS=$(aws secretsmanager get-secret-value --secret-id "$SECRET_NAME" --query SecretString --output text)
# Parse the JSON string from the DB_SECRETS variable
export DB_USERNAME=$(echo $DB_SECRETS | jq -r '.DBUsername')
export DB_PASSWORD=$(echo $DB_SECRETS | jq -r '.DBPassword')
export DB_NAME=$(echo $DB_SECRETS | jq -r '.DBName')
export DB_HOST=$(echo $DB_SECRETS | jq -r '.RDSEndpoint')

# Add current user to docker group 
sudo usermod -aG docker $USER
cd /home/ubuntu
git clone https://github.com/Kaydarkey/lampECS.git
cd lampECS
sudo docker build -t lamp:latest .
sudo docker run -d -p 80:80 --name lamp -e DB_USERNAME=$DB_USERNAME -e DB_PASSWORD=$DB_PASSWORD -e DB_NAME=$DB_NAME -e DB_HOST=$DB_HOST lamp:latest
