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
	namespace=$(echo "$2" | awk '{print tolower($0)}')
	namespace=$(sed -e 's/uta1/uat/g' -e 's/aut1/uat/g' -e 's/tua1/uat/g' <<< $namespace)
		 
case $namespace in
	uta2|uta3) 
		namespace=$(sed 's/uta/uat/g' <<< $namespace)
		;;	
	tua2|tua3) 
		namespace=$(sed 's/tua/uat/g' <<< $namespace)
		;;
	aut2|aut3) 
		namespace=$(sed 's/aut/uat/g' <<< $namespace)
		;;
	*)
		echo "Ambiente nao informado - Ex: uat, uat2, prd etc ..." 
esac

fi

pod=$(echo "$1" | awk '{print tolower($0)}')

getPods (){
kubectl get pods -A | grep $namespace | grep $pod
}

getPods $pod $namespace
