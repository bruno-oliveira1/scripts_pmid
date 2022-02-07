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

orch=$(echo "$1" | awk '{print tolower($0)}')
namespace=$(echo "$2" | awk '{print tolower($0)}')

if [ -z $namespace ]; then
	if [ -f  $HOME/namespace.txt ]; then
		namespace=$(< $HOME/namespace.txt)
	else
	echo "Ambiente nao informado e arquivo  $HOME/namespace.txt nao existe"
	exit 1
	fi
fi

if [ "`ls *serviceList.temp* 2> /dev/null | wc -l`" > 0 ]; then
    rm ${HOME}/serviceList.temp ${HOME}/var.temp 2> /dev/null
fi

serviceList () {

	echo "recuperando steps do $orch..."

    #servicos convencionais
	kubectl exec -i deploy/$orch -n $np -- bash -c "grep -i processid resources/*.bpmn" | cut -d \" -f 4 | sed -r 's/[A-Z]/-\L&/g' > ${HOME}/var.temp
    #rules
    kubectl exec -i deploy/$orch -n $np -- bash -c "grep -i httpUriTmplInline resources/*.bpmn" 2>/dev/null | grep -s rules | cut -d \/ -f 3 | cut -d \" -f 1 | cut -d \? -f 1 >> ${HOME}/var.temp
    
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

    #checkVersion.sh $1 $np | cut -d \/ -f 4
    versao=$(checkVersion.sh $1 $np | cut -d\: -f3)
    echo $1:"$versao"

while read -r line; do

    if [ "`echo $line | grep -i rules`" != "" ]; then
        versao=$(checkVersion.sh $line-v1 s-$np | cut -d\: -f3)
        echo $line:"$versao"
        else
        versao=$(checkVersion.sh $line $np | cut -d\: -f3)
        echo $line:"$versao"
    fi

done < "$input"
