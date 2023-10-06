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
    echo $namespace
  else
    echo "Ambiente nao informado e arquivo namespace.txt nao existe"
    exit 1
  fi
else
  namespace=$(echo "$2" | awk '{print tolower($0)}')
fi

pod=$(echo "$1" | awk '{print tolower($0)}')
na_namespace="$namespace"

if echo "$pod" | grep -q "gmid-"; then
  tipo="gmid/services"
  #servico=${pod/gmid-/}
  namespace="m-$na_namespace"
  versao=$(kubectl -n $namespace describe deploy $pod 2>/dev/null | grep -i Image | sed 's/.*pipeline-//')
  servico=$(kubectl -n $namespace describe deploy $pod 2>/dev/null | grep -i Image | awk -F\/ '{print $5}' | awk -F\: '{print $1}')
  if [[ $versao != "naoinstalado" && $versao != "" ]]; then
    id=$(curl -s --header "$tokenfull" -X GET https://gitlab.engdb.com.br/api/v4/projects?search=$servico | jq --arg tipo "$tipo" --arg servico "$servico" '.[] | select(.namespace.full_path == $tipo and .name == $servico) | .id')
    versao=$(curl -s --header "$tokenfull" -X GET https://gitlab.engdb.com.br/api/v4/projects/$id/pipelines?per_page=300 | jq --arg versao "$versao" '.[] | select(.id == ($versao | tonumber)) | .ref' --raw-output)
    pipeline=$(curl -s --header "$tokenfull" -X GET https://gitlab.engdb.com.br/api/v4/projects/$id/pipelines?per_page=300 | jq --arg versao "$versao" '.[] | select(.ref == $versao) | .id')
    echo -e "$pod $versao $namespace pipeline: https://gitlab.engdb.com.br/$tipo/$servico/-/pipelines/$pipeline"
    exit 0
  else
    echo -e "Nao instalado"
  fi
elif echo "$pod" | grep -q "rules-"; then
  servico="$pod"
  tipo="pmid/brms"
  namespace="s-$na_namespace"
  versao=$(kubectl -n $namespace describe deploy $pod 2>/dev/null | grep -i Image | sed 's#.*:##')
  id=$(curl -s --header "$tokenfull" -X GET https://gitlab.engdb.com.br/api/v4/projects?search=$servico | jq --arg tipo "$tipo" --arg servico "$servico" '.[] | select(.namespace.full_path == $tipo and .name == $servico) | .id')
  if [[ $versao != "naoinstalado" && $versao != "" ]]; then
    pipeline=$(curl -s --header "$tokenfull" -X GET https://gitlab.engdb.com.br/api/v4/projects/$id/pipelines?per_page=300 | jq --arg versao "$versao" '.[] | select(.ref == $versao) | .id')
    echo -e "$pod $versao $namespace pipeline: https://gitlab.engdb.com.br/$tipo/$servico/-/pipelines/$pipeline"
    exit 0
  else
    echo -e "Nao instalado"
  fi
else
  versao=$(kubectl -n $namespace describe deploy $pod 2>/dev/null | grep -i Image | sed 's#.*:##')
  if [[ $versao != "naoinstalado" && $versao != "" ]]; then
    servico="$pod"
    id=$(curl -s --header "$tokenfull" -X GET https://gitlab.engdb.com.br/api/v4/projects?search=$servico | jq --arg tipo "$tipo" --arg servico "$servico" '.[] | select(.namespace.full_path == $tipo and .name == $servico) | .id')
    echo -e "$pod $versao $namespace"
  else
    echo -e "Nao instalado"
  fi
fi
