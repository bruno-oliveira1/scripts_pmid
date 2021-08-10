#!/bin/bash
#
# getPods.sh - recupera todos os pods que contém em seu nome o parâmetro informado na atual namespace.
#
# Como usar: ". getPods.sh nome-do-pod"
#
# Exemplo:
#             . getPods.sh u-billing-prof
#             . getPods.sh u-billing-profile-info uat2
#
# Histórico de versões:
#       Versão: 1.0
#             Autor: Heitor Bellini <heitor.bellini@engdb.com.br>
#             Data: 06/2020
#             Descrição: Primeira versão.
#       Versão: 1.1
#             Autor: Flavio Moreira <flavio.moreira@engdb.com.br>
#             Data: 04/2021
#             Descrição: condição para o ambiente ser variável (caso não informe o ambiente será considerado o do namespace.txt)

if [ -z $2 ] 
then
	read -r namespace<namespace.txt
else
namespace=$2
fi
pod=$1

getPods (){
kubectl get pods -A | grep $namespace | grep $pod
}

getPods $pod $namespace

if [ $? -eq 0 ]
then
		echo ""
else
		echo ""
		echo "Utilize o script conforme o exemplo: . getPods.sh u-billing-profile-info uat2"
		echo ""
fi
