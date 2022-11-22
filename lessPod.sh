#!/bin/bash
#
# lessPod.sh - abre o log atual do pod informado em formato 'less'.
#
# Como usar: ". getPods.sh nome-do-pod"
#
# Exemplo:
#             . lessPod.sh imdb-read-status-by-msisdn-v1-7f4db868c5-pbhmr
#             . lessPod.sh imdb-read-status-by-msisdn-v1-7f4db868c5-pbhmr uat3
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

pod=$(echo "$1" | awk '{print tolower($0)}')
namespace=$(getPods.sh $pod | awk '{print $1}')

kubectl -n $namespace logs -f $pod | less 2>&-
