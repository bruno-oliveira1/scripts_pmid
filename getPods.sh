#!/bin/bash
#
# getPods.sh - recupera todos os pods que contém em seu nome o parâmetro informado na atual namespace.
#
#             
#Baseado no trabalho de Heitor Bellini <heitor.bellini@engdb.com.br> e Flavio Moreira <flavio.moreira@engdb.com.br>
#Migrado para gitlab e alterações feitas por Bruno Oliveira <bruno.oliveira2@engdb.com.br>

if [ -z $2 ]; then
	if [ -f namespace.txt ]; then
		read -r namespace<namespace.txt		
	else
	echo "Ambiente nao informado e arquivo namespace.txt nao existe"
	exit 1
	fi
else
	namespace=$(echo "$2" | awk '{print tolower($0)}')
	case $namespace in
		uta|uta2|uta3) 
			namespace=$(sed 's/uta/uat/g' <<< $namespace)
			;;
		tua|tua2|tua3) 
			namespace=$(sed 's/tua/uat/g' <<< $namespace)
			;;
		aut|aut2|aut3) 
			namespace=$(sed 's/aut/uat/g' <<< $namespace)
			;;
		uta1|tua1|aut1)
			namespace=$(sed -e 's/uta1/uat/g' -e 's/aut1/uat/g' -e 's/tua1/uat/g' <<< $namespace)
			;;
		uat|uat2|uat3|prd|dev)
			echo "Um momento ..."
			;;
		*)
			echo "Ambiente nao informado - Ex: uat, uat2, prd etc ..." 
	esac
fi

pod=$(echo "$1" | awk '{print tolower($0)}')

getPods (){
kubectl get pods -A | grep $namespace 2>/dev/null | grep $pod
}

getPods $pod $namespace