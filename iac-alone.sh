#!/bin/bash

# IaC - Script de configuração de um serviço web clusterizado com Docker Swarm


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

echo -e "###\nCriando Volumes\n###"
docker volume create app
docker volume create data

echo -e "###\nBaixando arquivos do projeto no GitHub\n###"
cd /var/lib/docker/app/_data
wget https://github.com/jpmjunior/dio-desafio-microservicos/archive/refs/heads/main.zip
apt-get install unzip -y
unzip main.zip
mv -r dio-desafio-microservicos-main/* .
rm -r dio-desafio-microservicos-main main.zip

echo -e "###\nCriando container do MySQL\n###"
docker run -e MYSQL_ROOT_PASSWORD=Senha123 -e MYSQL_DATABASE=meubanco --name mysql-A -d -p 3306:3306 --mount type=volume,src=data,dst=/var/lib/mysql/ mysql:5.7

echo -e "###\nCriando tabela através de comando armazendo em arquivo\n###"
docker exec -i mysql-A sh -c 'exec mysql -u root -p"$MYSQL_ROOT_PASSWORD" meubanco' < banco.sql

echo -e "###\nCriando container do Apache com PHP 7\n###"
sudo docker run --name web-server -dt -p 80:80 --mount type=volume,src=app,dst=/app/ webdevops/php-apache:alpine-php7
