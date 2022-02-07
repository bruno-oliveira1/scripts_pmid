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
namespace=$(echo "$2" | awk '{print tolower($0)}')

if [ -z $namespace ]; then
	if [ -f  $HOME/namespace.txt ]; then
		namespace=$(< $HOME/namespace.txt)
	else
	echo "Ambiente nao informado e arquivo  $HOME/namespace.txt nao existe"
	exit 1
	fi
fi

kubectl -n $namespace logs -f $pod | less 2>&-