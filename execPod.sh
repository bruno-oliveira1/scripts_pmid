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

kubectl -n $namespace exec -it deploy/$pod /bin/bash
