#!/bin/bash
#
# pmidChange.sh - retorna toda a árvore se serviços (e respectivas versões) do orquestrador informado
#
# Como usar: ". pmidChange.sh nome-do-orch-v1"
#
# Exemplo:
#             . pmidChange.sh orch-r-access-information-v1
#
# Histórico de versões:
#       Versão: 1.0
#             Autor: Heitor Bellini <heitor.bellini@engdb.com.br>
#             Data: 04/2020
#             Descrição: Primeira versão.

namespace=$(echo "$2" | awk '{print tolower($0)}')
if [ -z $namespace ]; then
	if [ -f  $HOME/namespace.txt ]; then
		namespace=$(< $HOME/namespace.txt)
	else
	echo "Ambiente nao informado e arquivo  $HOME/namespace.txt nao existe"
	exit 1
	fi
fi

if [ -e ${HOME}/serviceList.temp ]; then
    rm ${HOME}/serviceList.temp ${HOME}/var.temp
fi

serviceList () {

orch=$(echo "$1" | awk '{print tolower($0)}')

	echo "recuperando steps do $orch..."

    #servicos convencionais
	kubectl exec -it deploy/$orch -n $namespace -- bash -c "grep -i processid resources/*.bpmn" 2>/dev/null | cut -d \" -f 4 | sed -r 's/[A-Z]/-\L&/g' > ${HOME}/var.temp
    #rules
    kubectl exec -it deploy/$orch -n $namespace -- bash -c "grep -i httpUriTmplInline resources/*.bpmn" 2>/dev/null | grep -s rules | cut -d \/ -f 3 | cut -d \" -f 1 | cut -d \? -f 1 >> ${HOME}/var.temp
    
	for serviceItem in `sort ${HOME}/var.temp | uniq`; do

		echo "$serviceItem" >> ${HOME}/serviceList.temp

		if [ "`echo $serviceItem | grep orch`" != "" ]; then
			serviceList $serviceItem
		fi

	done
}

serviceList $1

input=${HOME}/serviceList.temp

printf "______________________________________________________________________\n\nResultado:\n"

versao=$(checkVersion.sh $1 $namespace | awk -F ' ' '{print $2}')
echo -e "$1 $versao" 

if [ -e $input ]; then

while read -r line; do

    if [ "`echo $line | grep -i rules`" != "" ]; then
        versao=$(checkVersion.sh $line-v1 s-$namespace  | awk -F ' ' '{print $2}')
		echo -e "$line-v1 $versao"
    else
        versao=$(checkVersion.sh $line $namespace 2> /dev/null | awk -F ' ' '{print $2}')
		echo -e "$line $versao"
    fi

done < "$input"

else 
exit
fi