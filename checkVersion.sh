#!/bin/bash
#
# checkVersion.sh - Checa a versão do serviço no ambiente.
#
#Baseado no trabalho de Felipe de Carvalho Alencar <felipe.alencar@engdb.com.br>
#Migrado para gitlab e alterações feitas por Bruno Oliveira <bruno.oliveira2@engdb.com.br>

token=$(cat $HOME/token 2>/dev/null)
if [[ $token == "" ]]; then
  echo "Eh necessario ter um token criado no GitLab que o mesmo esteja dentro do arquivo $HOME/token"
  echo "Para que esse script funcione"
  echo 'Ex: cat $HOME/token'
  echo 'pqamgereorppreq'
  exit 1
fi

tokenfull="Authorization: Bearer $token"

if [ -z $2 ]; then
  if [ -f $HOME/namespace.txt ]; then
    read -r namespace <$HOME/namespace.txt
  else
    echo "Ambiente nao informado e arquivo namespace.txt nao existe"
    exit 1
  fi
else
  namespace=$(echo "$2" | awk '{print tolower($0)}')
fi

pod=$(echo "$1" | awk '{print tolower($0)}')
checkVersion() {
  kubectl -n $namespace describe deploy $pod 2>/dev/null | grep -i Image || kubectl -n m-$namespace describe deploy $pod 2>/dev/null | grep -i Image || kubectl -n s-$namespace describe deploy $pod 2>/dev/null | grep -i Image || kubectl -n e-$namespace describe deploy $pod 2>/dev/null | grep -i Image || versao=naoinstalado
}

if echo "$pod" | grep -q "gmid-"; then
  tipo="gmid/services"
  servico=${pod/gmid-/}
  versao=$(checkVersion | sed 's/.*pipeline-//')
  id=$(curl -s --header "$tokenfull" -X GET https://gitlab.engdb.com.br/api/v4/projects?search=$servico | jq --arg tipo "$tipo" --arg servico "$servico" '.[] | select(.namespace.full_path == $tipo and .name == $servico) | .id')
  versao=$(curl -s --header "$tokenfull" -X GET https://gitlab.engdb.com.br/api/v4/projects/$id/pipelines?per_page=300 | jq --arg versao "$versao" '.[] | select(.id == ($versao | tonumber)) | .ref' --raw-output)
  pipeline=$(curl -s --header "$tokenfull" -X GET https://gitlab.engdb.com.br/api/v4/projects/$id/pipelines?per_page=300 | jq --arg versao "$versao" '.[] | select(.ref == $versao) | .id')
  echo -e "$pod $namespace $versao pipeline: https://gitlab.engdb.com.br/gmid/$tipo/$servico/-/pipelines/$pipeline"
  exit 0
else
  checkVersion >/dev/null
fi

case "$versao" in
naoinstalado)
  echo -e "Nao instalado"
  ;;
*)
  versao=$(checkVersion $pod $namespace | awk -F : '{print $3}')
  echo -e "$pod $versao $ambiente"
  ;;
esac
