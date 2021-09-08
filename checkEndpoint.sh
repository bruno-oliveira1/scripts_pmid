#!/bin/bash
#
# checkEndpoint.sh - Checa o host e port do serviço.
#
#Baseado no trabalho de Felipe de Carvalho Alencar <felipe.alencar@engdb.com.br> e Heitor Bellini <heitor.bellini@engdb.com.br>
#Migrado para gitlab e alterações feitas por Bruno Oliveira <bruno.oliveira2@engdb.com.br>

checkEndpoint (){
if [ "`kubectl -n $namespace describe deploy $svc | grep -i db_host`" != "" ]; then

        kubectl -n $namespace describe deploy $svc > dbadapter.temp
        user=`cat dbadapter.temp | grep -i user_db | cut -d : -f 2 | sed 's/^ *//g'`
        password=`cat dbadapter.temp | grep -i password_db | cut -d : -f 2 | sed 's/^ *//g'`
        host=`cat dbadapter.temp | grep -i db_host | cut -d : -f 2 | sed 's/^ *//g'`
        port=`cat dbadapter.temp | grep -i db_port | cut -d : -f 2 | sed 's/^ *//g'`
        schema=`cat dbadapter.temp | grep -i schema | cut -d : -f 2 | sed 's/^ *//g'`
        echo "PROVIDER_ADDRESS:      $user/$password@$host:$port/$schema"

        mapper=`kubectl exec -it deploy/$svc -n $namespace -- bash -c "grep -i mapper resources/*.bpmn" | cut -d \" -f 4 | sed 's/^ *//g'`

        proc=`kubectl exec -it deploy/$svc -n $namespace -- bash -c "grep -i call resources/mappers/$mapper-$namespace.xml" | grep -i -v callable | sed 's/^ *//g' | cut -d \( -f 1 | cut -d ' ' -f 2`
        echo "PROCEDURE:             $proc"

else
        kubectl -n $namespace describe deploy $svc | grep -i provider_address | sed 's/^ *//g'
fi
}


svc=$(echo $1 | sed -r 's/[A-Z]/\L&/g')
if [ -z $svc ]; then
	svc=help
fi
	case $svc in
		help)
			echo "Uso checkEndpoint.sh serviço ambiente"
			echo "Ex: checkEndpoint.sh r-access-info uat"
			exit 1
	esac

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
			checkEndpoint $svc $namespace
			;;
		tua|tua2|tua3)
			namespace=$(sed 's/tua/uat/g' <<< $namespace)
			checkEndpoint $svc $namespace
			;;
		aut|aut2|aut3)
			namespace=$(sed 's/aut/uat/g' <<< $namespace)
			checkEndpoint $svc $namespace
			;;
		uta1|tua1|aut1)
			namespace=$(sed -e 's/uta1/uat/g' -e 's/aut1/uat/g' -e 's/tua1/uat/g' <<< $namespace)
			checkEndpoint $svc $namespace
			;;
		uat|uat2|uat3|prd|dev)
			checkEndpoint $svc $namespace
			;;
		*)
			echo "Ambiente informado diferente do esperado - Ex: uat, uat2, prd etc ..."
			echo "Ex: checkEndpoint.sh r-access-info uat"
			exit 1 
	esac
	fi
