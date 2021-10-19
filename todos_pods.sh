#!/bin/bash
#
# todos_pods.sh - Traz uma lista de todos os serviços instalados no ambiente.
#

todospods (){
	> pods_$namespace
		#kubectl -n $namespace describe deploy | grep Name: | awk '{print $2}' >> pods_$namespace
		kubectl get pods -A | grep -w $namespace | awk '{print $2}' >> pods_$namespace
	}

if [ -z $1 ]; then
	if [ -f namespace.txt ]; then
		read -r namespace<namespace.txt
	else
		echo "Ambiente nao informado e arquivo namespace.txt nao existe"
		exit 1
	fi
else
	namespace=$(echo "$1" | awk '{print tolower($0)}')
	case $namespace in
		uta|uta2|uta3)
                        namespace=$(sed 's/uta/uat/g' <<< $namespace)
                        todospods
                        ;;
                tua|tua2|tua3)
                        namespace=$(sed 's/tua/uat/g' <<< $namespace)
                        todospods
                        ;;
                aut|aut2|aut3)
                        namespace=$(sed 's/aut/uat/g' <<< $namespace)
                        todospods
                        ;;
                uat1|uta1|tua1|aut1)
                        namespace=$(sed -e 's/uat1/uat/' -e 's/uta1/uat/g' -e 's/aut1/uat/g' -e 's/tua1/uat/g' <<< $namespace)
                        todospods
                        ;;
                uat|uat2|uat3|prd|dev)
                        todospods
                        ;;
                *)
                        echo "Ambiente informado diferente do esperado - Ex: uat, uat2, prd etc ..."
        esac
fi
