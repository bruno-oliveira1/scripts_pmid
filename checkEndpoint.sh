#!/bin/bash
#
# checkEndpoint.sh - Checa o host e port do serviço.
#
# Como usar: ". checkEndpoint.sh ambiente nome-do-pod-v1" para checar o host e port no ambiente.
#
# Exemplo:
#       felipe_alencar@cloudshell:~$ . checkEndpoint.sh u-billing-profile-info-v1 uat3
#
# Histórico de versões:
#       Versão: 1.0
#             Autor: Felipe de Carvalho Alencar <felipe.alencar@engdb.com.br>
#             Data: 01/2021
#             Descrição: Primeira versão.
#       Versão: 2.0
#             Autor: Heitor Bellini <heitor.bellini@engdb.com.br>
#             Data: 04/2021
#             Descrição: Nome do pod não é mais case sensitive. Agora traz o apontamento de db adapters. Namespace referenciada ao namespace.txt.

if [ -z $2 ] 
then
	read -r np<namespace.txt
else
np=$2
fi
svc=`echo $1 | sed -r 's/[A-Z]/\L&/g'`

checkEndpoint (){
if [ "`kubectl -n $np describe deploy $svc | grep -i db_host`" != "" ]; then

        kubectl -n $np describe deploy $svc > dbadapter.temp
        user=`cat dbadapter.temp | grep -i user_db | cut -d : -f 2 | sed 's/^ *//g'`
        password=`cat dbadapter.temp | grep -i password_db | cut -d : -f 2 | sed 's/^ *//g'`
        host=`cat dbadapter.temp | grep -i db_host | cut -d : -f 2 | sed 's/^ *//g'`
        port=`cat dbadapter.temp | grep -i db_port | cut -d : -f 2 | sed 's/^ *//g'`
        schema=`cat dbadapter.temp | grep -i schema | cut -d : -f 2 | sed 's/^ *//g'`
        echo "PROVIDER_ADDRESS:      $user/$password@$host:$port/$schema"

        mapper=`kubectl exec -it deploy/$svc -n $np -- bash -c "grep -i mapper resources/*.bpmn" | cut -d \" -f 4 | sed 's/^ *//g'`

        proc=`kubectl exec -it deploy/$svc -n $np -- bash -c "grep -i call resources/mappers/$mapper.xml" | grep -i -v callable | sed 's/^ *//g' | cut -d \( -f 1 | cut -d ' ' -f 2`
        echo "PROCEDURE:             $proc"

else
        kubectl -n $np describe deploy $svc | grep -i provider_address | sed 's/^ *//g'
fi
}

checkEndpoint $svc $np

##echo "$?"
##if [ $? -eq 0 ]
#then
 #       echo ""
#else
#        echo ""
#		echo "Utilize o script conforme o exemplo: . checkEndpoint.sh u-billing-profile-info-v1 uat3"
#		echo ""
#fi
