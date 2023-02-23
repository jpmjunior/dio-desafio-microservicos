#!/bin/bash

# IaC - Script de configuração de um serviço web modo stand-alone.
#
# Pré-requesito: Docker Engine instalado.

echo -e "###\nCriando Volumes\n###"
docker volume create app
docker volume create data

echo -e "###\nBaixando arquivos do projeto no GitHub\n###"
cd /var/lib/docker/volumes/app/_data
wget https://github.com/jpmjunior/dio-desafio-microservicos/archive/refs/heads/main.zip
apt-get install unzip -y
unzip main.zip
mv -v dio-desafio-microservicos-main/* .
rm -rv dio-desafio-microservicos-main main.zip

echo -e "###\nCriando container do MySQL\n###"
docker run -e MYSQL_ROOT_PASSWORD=Senha123 -e MYSQL_DATABASE=meubanco --name mysql-A -d -p 3306:3306 --mount type=volume,src=data,dst=/var/lib/mysql/ mysql:5.7

echo -e "###\nCriando container do Apache com PHP 7\n###"
sudo docker run --name web-server -dt -p 80:80 --mount type=volume,src=app,dst=/app/ webdevops/php-apache:alpine-php7

echo -e "###\nCriando tabela através de comando armazendo em arquivo\n###"
docker exec -i mysql-A sh -c 'exec mysql -u root -p"$MYSQL_ROOT_PASSWORD" meubanco' < banco.sql
