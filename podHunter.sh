#!/bin/bash
#
# podHunter.sh - Retorna os pods onde a TID informada é encontrada. Baseado no pmidChange.sh
#
# Como usar: ". podHunter.sh nome-do-orch-v1 TID ambiente"
#			 ". podHunter.sh nome-do-orch-v1 TID"
# Exemplo:
#             . podHunter.sh orch-r-access-information-v1 9D487C430D3E4E4C8DEC9AE1 uat
#			  . podHunter.sh orch-r-access-information-v1 9D487C430D3E4E4C8DEC9AE1
#
# Histórico de versões:
#       Versão: 1.0
#             Autor: Felipe de Carvalho Alencar <felipe.alencar@engdb.com.br>
#             Data: 05/2020
#             Descrição: Primeira versão.
#

tid=$2
rm pods.txt 2> /dev/null
rm foundpods.txt  2> /dev/null
if [ $3 != "" 2>/dev/null ]; then 
    np=$3
else
    read -r np<namespace.txt
fi

if [ "`cat *serviceList.temp* | wc -l`" > 0 ]; then
    rm ${HOME}/serviceList.temp ${HOME}/var.temp 2> /dev/null
fi

echo -ne '#####\r'
sleep 1
	
serviceList () {

	orch=$1
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

kubectl -n $np get pods | grep -i $1 | awk '{print $1'} >> pods.txt

while read -r line; do

        kubectl -n $np get pods | grep -i $line | awk '{print $1'} >> pods.txt

done < "$input"
echo -ne '##########\r'


LOCK_FILE="pods.txt"

VerificaLockFile()
{
   if [ -f ${LOCK_FILE} ]
     then
        while read -r linha
        do
           `timeout -k 5 5 kubectl -n $np logs -f $linha 2> /dev/null | grep -q $tid`
		   	if [ $? -eq 0 ]
			then 
				echo $linha >> foundpods.txt
			fi
        done < "${LOCK_FILE}"
    fi
}
echo -ne '###############\r'
VerificaLockFile
echo -ne '####################\r'
echo -ne '\n'
echo ""
printf "TID encontrada nos pods:"
echo ""
cat foundpods.txt
echo ""
