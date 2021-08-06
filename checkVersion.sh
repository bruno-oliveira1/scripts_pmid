#!/bin/bash
#
# checkVersion.sh - Checa a versão do serviço no ambiente.
#
# Como usar: ". checkVersion.sh nome-do-pod-v1 ambiente" para checar a versão no ambiente.
#
# Exemplo:
#       felipe_alencar@cloudshell:~$ . checkVersion.sh bscsix-read-simcard-data-v1 uat2
#
# Obs: Deve-se considerar apenas os 3 primeiros digitos, pois o ultimo digito é usado pela fabrica.
#
# Histórico de versões:
#       Versão: 1.0
#             Autor: Felipe de Carvalho Alencar <felipe.alencar@engdb.com.br>
#             Data: 01/2021
#             Descrição: Primeira versão.

if [ -z $2 ] 
then
	read -r namespace<namespace.txt
else
namespace=$2
fi
pod=$1

checkVersion (){
kubectl -n $namespace describe deploy $pod | grep -i Image
}

checkVersion $pod $namespace
if [ $? -eq 0 ]
then
        echo ""
else
        echo ""
		echo "Utilize o script conforme o exemplo: . checkVersion.sh bscsix-read-simcard-data-v1 uat2"
		echo ""
fi
