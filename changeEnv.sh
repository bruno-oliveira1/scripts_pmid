#!/bin/bash
#
# changeEnv - Muda o cluster para fqa, dev ou prd.
#
# Como usar: ". changeEnv.sh ambiente" e aguarde para mudar de cluster.
#
# Exemplo:
#		felipe_alencar@cloudshell:~$ . changeEnv.sh prd
#
# Histórico de Versão:
#       Versão: 1.0
#             Autor: Felipe de Carvalho Alencar <felipe.alencar@engdb.com.br>
#             Data: 08/12/2020
#             Descrição: Primeira versão.
#       Versão: 2.0
#             Autor: Felipe de Carvalho Alencar <felipe.alencar@engdb.com.br>
#             Data: 03/05/2020
#             Descrição: Mudança para "case" e validação de entrada.
#

namespace=$(echo "$1" | awk '{print tolower($0)}')

if [ -z $namespace ]; then
	if [ -f  $HOME/namespace.txt ]; then
		namespace=$(< $HOME/namespace.txt)
	else
	echo "Ambiente nao informado e arquivo $HOME/namespace.txt nao existe"
	exit 1
	fi
fi

case $namespace in
        dev)
        gcloud config set project tim-pmid-dev 1>&- 2>&-
        gcloud config set compute/region southamerica-east1 1>&- 2>&- 
        gcloud container clusters get-credentials pmid-dev --region=southamerica-east1 1>&- 2>&-
        sed -i "1 s/^.*$/dev/" $HOME/namespace.txt
        echo "Você entrou no cluster DEV"
        ;;

        fqa)
        gcloud config set project tim-pmid-fqa 1>&- 2>&-                                                                                            
	gcloud config set compute/region southamerica-east1 1>&- 2>&-                                                                                           
	gcloud container clusters get-credentials tim-pmid-uat --region southamerica-east1 --project tim-pmid-fqa 1>&- 2>&-
        sed -i "1 s/^.*$/uat/" $HOME/namespace.txt
	echo "Você entrou no cluster FQA"
        ;;

        prd)
	gcloud config set project tim-pmid-prd 1>&- 2>&-
	gcloud config set compute/region southamerica-east1 1>&- 2>&-
	gcloud container clusters get-credentials pmid-prod --region=southamerica-east1 1>&- 2>&-
        sed -i "1 s/^.*$/prd/" $HOME/namespace.txt
	echo "Você entrou no cluster PRD"
        ;;

        *)
        echo "Ambiente informado invalido"
        ;;
esac
