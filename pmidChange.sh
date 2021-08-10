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

if [ $2 != "" 2>/dev/null ]; then
    np=$2
else
    read -r np<namespace.txt
fi

if [ "`ls *serviceList.temp* | wc -l`" > 0 ]; then
    rm ${HOME}/serviceList.temp ${HOME}/var.temp
fi

serviceList () {

	orch=$1

	echo "recuperando steps do $orch..."

    #servicos convencionais
	kubectl exec -it deploy/$orch -n $np -- bash -c "grep -i processid resources/*.bpmn" | cut -d \" -f 4 | sed -r 's/[A-Z]/-\L&/g' > ${HOME}/var.temp
    #rules
    kubectl exec -it deploy/$orch -n $np -- bash -c "grep -i httpUriTmplInline resources/*.bpmn" 2>/dev/null | grep -s rules | cut -d \/ -f 3 | cut -d \" -f 1 | cut -d \? -f 1 >> ${HOME}/var.temp
    
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

. checkVersion.sh $1 $np | cut -d \/ -f 3

while read -r line; do

    if [ "`echo $line | grep -i rules`" != "" ]; then
        . checkVersion.sh $line-v1 s-$np | cut -d \/ -f 3
    else
        . checkVersion.sh $line $np | cut -d \/ -f 3
    fi

done < "$input"
