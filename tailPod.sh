#!/bin/bash
#
# tailPod.sh - possibilita acompanhar o log do pod informado em tempo real.
#
# Como usar: ". tailPod.sh nome-do-pod-v1-podId"
#
# Exemplo:
#             . tailPod.sh imdb-read-status-by-msisdn-v1-7f4db868c5-pbhmr
#             . tailPod.sh imdb-read-status-by-msisdn-v1-7f4db868c5-pbhmr uat3
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

if [ $2 null ]
then
    read -r np<namespace.txt
    kubectl -n $np logs -f $1
else
    kubectl -n $2 logs -f $1
fi 2>&-
