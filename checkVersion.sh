#!/bin/bash
#
# checkVersion.sh - Checa a versão do serviço no ambiente.
#
#Baseado no trabalho de Felipe de Carvalho Alencar <felipe.alencar@engdb.com.br>
#Migrado para gitlab e alterações feitas por Bruno Oliveira <bruno.oliveira2@engdb.com.br>

if [ -z $2 ]; then
	if [ -f $HOME/namespace.txt ]; then
		read -r namespace<$HOME/namespace.txt
	else
		echo "Ambiente nao informado e arquivo namespace.txt nao existe"
		exit 1
	fi
else
	namespace=$(echo "$2" | awk '{print tolower($0)}')
	fi

pod=$(echo "$1" | awk '{print tolower($0)}')
checkVersion (){
	kubectl -n $namespace describe deploy $pod 2>/dev/null | grep -i Image || kubectl -n m-$namespace describe deploy $pod 2>/dev/null | grep -i Image || kubectl -n s-$namespace describe deploy $pod 2>/dev/null | grep -i Image || kubectl -n e-$namespace describe deploy $pod 2>/dev/null | grep -i Image || versao=naoinstalado
}

checkVersion > /dev/null

case "$versao" in
        naoinstalado)
		echo -e "Nao instalado"
        ;;
        *)
        versao=$(checkVersion $pod $namespace  | awk -F : '{print $3}')
		echo -e "$pod $versao $ambiente"
esac
