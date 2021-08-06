#!/bin/bash
#
# execPod.sh - fornece acesso de root ao pod informado.
#
# Como usar: ". execPod.sh nome-do-pod-v1"
#
# Exemplo:
#             . execPod.sh u-billing-profile-info-v1
#
# Histórico de versões:
#       Versão: 1.0
#             Autor: Heitor Bellini <heitor.bellini@engdb.com.br>
#             Data: 08/2020
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

kubectl -n $namespace exec -it deploy/$pod /bin/bash
