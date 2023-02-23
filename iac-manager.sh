#!/bin/bash

# Pré-requesitos: 
#   3 VMs Ubuntu com Docker Engine instalado;
#   e script iac-alone.sh já executado na primeira VM.


echo -e "###\nEncerrando container web-server antes de iniciar o Docker Swarm\n###"
docker rm --force web-server

echo -e "###\nIniciando cluster Docker Swarm\n###"
docker swarm init

# Espera retorno do usuário para continuar

echo "Execute o comando ``docker swarm join ...`` sugerido acima nas outras máquinas que integrarão o cluster."
echo "(continuar/cancelar)"
read RESPOSTA

# while [[${RESPOSTA} -ne "continuar"]];do
	# if [ ${RESPOSTA} -eq "cancelar" ];then
		# break
	# echo "(continuar/cancelar)"
	# read RESPOSTA
# done

echo -e "###\nCriando 10 réplicas do conteiner Apache com PHP 7\n###"
docker service create --name web-server --replicas 10 -dt -p 80:80 --mount type=volume,src=app,dst=/app/ webdevops/php-apache:alpine-php7

echo -e "###\nIniciando e configurando NFS Server\n###"
apt-get install nfs-server -y
echo "/var/lib/docker/volumes/app/_data *(rw,sync,subtree_check)" >> /etc/exports
exportfs -ar

echo -e "###\nCriando container do proxy NGIX\n###"
docker build -t proxy-app .
docker run --name my-proxy-app -dti -p 4500:4500 proxy-app