#!/bin/bash

# Instalação do Docker Engine no Ubuntu Server 22.04.1
# Tutorial completo em https://docs.docker.com/engine/install/ubuntu/

echo -e "###\nInstalação do Docker no Ubuntu 22.04.1\n###"

echo -e "###\nInstalando pacotes para permitir uso do APT sobre HTTPS\n###"
apt-get update
apt-get install ca-certificates curl gnupg lsb-release -y

echo -e "###\nAdicionando chave oficial do Docker\n###"
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo -e "###\nAdicionando repositório oficial do Docker\n###"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo -e "###\nInstalando Docker Engine, containerd e Docker Compose\n###"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
