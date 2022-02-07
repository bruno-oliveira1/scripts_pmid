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

pod=$(echo "$1" | awk '{print tolower($0)}')
namespace=$(echo "$2" | awk '{print tolower($0)}')

if [ -z $namespace ]; then
	if [ -f  $HOME/namespace.txt ]; then
		namespace=$(< $HOME/namespace.txt)
	else
	echo "Ambiente nao informado e arquivo  $HOME/namespace.txt nao existe"
	exit 1
	fi
fi

kubectl -n $namespace logs -f $pod 2>&-
