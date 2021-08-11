#!/bin/bash
#
# restartwli.sh - Identifica em qual ambiente está sendo executado e se for UAT1 e UAT2
# e faz o restart 
#
# Histórico de versões:
#       Versão: 1.0
#               Author: Bruno da Silva Oliveira <bruno.oliveira2@engdb.com.br>
#               Date: XX/08/2021
#               Descrição: Versão inicial.
#

processos1 () {
	processos=$(ps -ef | grep java | grep fqa1 | grep -v grep | awk -F' ' '{ print $2 }' 2> /dev/null)
}

processos2 () {
	processos=$(ps -ef | grep java | grep uat2 | grep -v grep | awk -F' ' '{ print $2 }' 2> /dev/null)
}

matarprocessos () {
if [ -z "$processos" ]; then 
	echo Processos inexistentes
else
	kill -9 $processos
	echo Processos finalizados
fi
}

restart1 () {
	cd /soa/fqa1/user_projects/domains/IB_FQA1_DOM
	./startNodeManager.sh && ./startWebLogic.sh && echo
}

restart2 () {
	cd /appl/uat2/domains/wli_uat2_domain
	./startNodeManager.sh && ./startWebLogic.sh && echo
}

hostname=$(hostname)
user=$(whoami)

if [ "$hostname" == snehpub6 ] && [ "$user" == fqa1  ]; then
	processos1 && matarprocessos
	processos1 && matarprocessos 
	processos1 && matarprocessos
	restart1
elif [ "$hostname" == snelnx185 ] && [ "$user" == uat2  ]; then
	processos2 && matarprocessos 
	processos2 && matarprocessos
	processos2 && matarprocessos
	restart2
else
	echo Erro provavelmente esse não é um host WLI
fi