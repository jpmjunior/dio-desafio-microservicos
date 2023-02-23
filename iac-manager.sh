#!/bin/bash

# IaC - Script de configuração de um serviço web clusterizado com Docker Swarm
#
# Pré-requesitos: 
#   3 VMs Ubuntu com Docker Engine instalado;
#   e script iac-alone.sh já executado na primeira VM.

echo -e "###\nIniciando e configurando NFS Server\n###"
apt-get install nfs-server -y
echo "/var/lib/docker/volumes/app/_data *(rw,sync,subtree_check)" >> /etc/exports
exportfs -ar

echo -e "###\nCriando container do proxy NGIX\n###"
docker build -t proxy-app .
docker run --name my-proxy-app -dti -p 4500:4500 proxy-app

echo -e "###\nEncerrando container web-server antes de iniciar o Docker Swarm\n###"
docker rm --force web-server

echo -e "###\nIniciando cluster Docker Swarm\n###"
docker swarm init
echo -e "###\nExecute o comando sugerido acima em todas as máquinas do cluster antes de continuar\n###"
read ANY

# Este comando deve ser executado somente após incluir todas a máquinas no cluster
echo -e "###\nCriando 10 réplicas do conteiner Apache com PHP 7\n###"
docker service create --name web-server --replicas 10 -dt -p 80:80 --mount type=volume,src=app,dst=/app/ webdevops/php-apache:alpine-php7