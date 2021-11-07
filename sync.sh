#!/bin/bash
#
# getPods.sh - recupera todos os pods que contém em seu nome o parâmetro informado na atual namespace.
#
#
#Baseado no trabalho de Heitor Bellini <heitor.bellini@engdb.com.br> e Flavio Moreira <flavio.moreira@engdb.com.br>
#Migrado para gitlab e alterações feitas por Bruno Oliveira <bruno.oliveira2@engdb.com.br>

getPods (){
kubectl get pods -A | grep $namespace 2>/dev/null | grep $pod
}

pod=$(echo "$1" | awk '{print tolower($0)}')
namespace=$(echo "$2" | awk '{print tolower($0)}')

if [ -z $namespace ]; then
        if [ -f namespace.txt ]; then
                read -r namespace<namespace.txt
        else
        echo "Ambiente nao informado e arquivo namespace.txt nao existe"
        exit 1
        fi
else
        case $namespace in
                uta|uta2|uta3)
                        namespace=$(sed 's/uta/uat/g' <<< $namespace)
                        getPods $pod $namespace
                        ;;
                tua|tua2|tua3)
                        namespace=$(sed 's/tua/uat/g' <<< $namespace)
                        getPods $pod $namespace
                        ;;
                aut|aut2|aut3)
                        namespace=$(sed 's/aut/uat/g' <<< $namespace)
                        getPods $pod $namespace
                        ;;
                uat1|uta1|tua1|aut1)
                        namespace=$(sed -e 's/uat1/uat/' -e 's/uta1/uat/g' -e 's/aut1/uat/g' -e 's/tua1/uat/g' <<< $namespace)
                        getPods $pod $namespace
                        ;;
                uat|uat2|uat3|prd|dev)
                        getPods $pod $namespace
                        ;;
                *)
                        echo "Ambiente informado diferente do esperado - Ex: uat, uat2, prd etc ..."
        esac
fi

