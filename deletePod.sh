#!/bin/bash
#
# deletePod.sh - deleta o pod informado.
#
# Como usar: ". deletePod.sh nome-do-pod-v1-podId"
#
# Exemplo:
#             . deletePod.sh u-billing-profile-info-v1-6cf54c8584-kzrmg
#             . deletePod.sh u-billing-profile-info-v1-6cf54c8584-kzrmg uat2
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

kubectl -n $namespace delete pod $pod
