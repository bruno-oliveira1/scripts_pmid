#!/bin/bash
#
# editDeploy.sh - possibilita editar o deployment de um serviço.
#
# Como usar: ". editDeploy.sh nome-do-pod-v1"
#
# Exemplo:
#             . editDeploy.sh u-billing-profile-info-v1
#             . editDeploy.sh u-billing-profile-info-v1 uat2
#
# Histórico de versões:
#       Versão: 1.0
#             Autor: Felipe de Carvalho Alencar <felipe.alencar@engdb.com.br>
#             Data: 12/2020
#             Descrição: Primeira versão.
#       Versão: 1.1
#             Autor: Flavio Moreira <flavio.moreira@engdb.com.br>
#             Data: 04/2021
#             Descrição: condição para o ambiente ser variável (caso não informe o ambiente será considerado o do namespace.txt)

if [ $2 null ]
then
    read -r np<namespace.txt
    kubectl -n $np edit deploy $1
else
    kubectl -n $2 edit deploy $1
fi 2>&-
