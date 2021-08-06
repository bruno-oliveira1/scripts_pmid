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

if [ -z $1 ]
then
namespace=$1
	#enquanto vazio o script pergunta qual deve ser passado até que o usuario passe algum
        while [ -z $namespace ]
        do
                read -p "Voce esqueceu de colocar o namespace (fqa, prd ou dev): " namespace
                letra_up=$(echo $namespace | awk '{ print toupper($1) }')
        done
else
	#troca a entrada para letras maisculas
        letra_up=$(echo $1 | awk '{ print toupper($1) }')
fi

case $letra_up in
        DEV)
        gcloud config set project tim-pmid-dev
        gcloud config set compute/region southamerica-east1 
        gcloud container clusters get-credentials pmid-dev --region=southamerica-east1
        echo "Você entrou no cluster DEV"
        ;;

        FQA)
        gcloud config set project tim-pmid-fqa                                                                                              
		gcloud config set compute/region southamerica-east1                                                                                           
		gcloud container clusters get-credentials tim-pmid-uat --region southamerica-east1 --project tim-pmid-fqa
		echo "Você entrou no cluster FQA"
        ;;

        PRD)
		gcloud config set project tim-pmid-prd 
		gcloud config set compute/region southamerica-east1                                                                                              
		gcloud container clusters get-credentials pmid-prod --region=southamerica-east1
		echo "Você entrou no cluster PRD"
        ;;

        *)
        echo "Parametro invalido"
        ;;
esac
