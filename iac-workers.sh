#!/bin/bash

# IaC - Script de configuração de um serviço web clusterizado com Docker Swarm - Workers nodes
#
# Execute este script somente após executar o docker swarm join ...

echo -e "###\nConfigurando clientes NFS\n###"
apt-get install nfs-common -y
mount -o v3 192.168.0.11:/var/lib/docker/volumes/app/_data /var/lib/docker/volumes/app/_data