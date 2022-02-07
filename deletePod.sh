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

namespace=$(echo "$2" | awk '{print tolower($0)}')

if [ -z $namespace ]; then
	if [ -f  $HOME/namespace.txt ]; then
		namespace=$(< $HOME/namespace.txt)
	else
	echo "Ambiente nao informado e arquivo $HOME/namespace.txt nao existe"
	exit 1
	fi
fi

pod=$(echo "$1" | awk '{print tolower($0)}')

kubectl -n $namespace delete pod $pod
