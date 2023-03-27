#!/bin/bash
servico=$1
token=$(cat $HOME/token)

versao=$(checkVersion.sh $servico $2 | awk -F ' ' '{print $2}')
nome=( $(curl -s --header "Authorization: Bearer $token" -X GET https://gitlab.engdb.com.br/api/v4/projects?search=$servico | jq '.[].name' |  sed 's/"//g' ) )
names=( $(curl -s --header "Authorization: Bearer $token" -X GET https://gitlab.engdb.com.br/api/v4/projects?search=$servico | jq '.[].path_with_namespace' |  sed 's/"//g' | awk -F/ '{print $1}' ) ) 
names2=( $(curl -s --header "Authorization: Bearer $token" -X GET https://gitlab.engdb.com.br/api/v4/projects?search=$servico | jq '.[].path_with_namespace' |  sed 's/"//g' | awk -F/ '{print $2}' ) ) 
ids=( $(curl -s --header "Authorization: Bearer $token" -X GET https://gitlab.engdb.com.br/api/v4/projects?search=$servico | jq '.[].id' ) ) 

i=0
while [ $i -lt ${#names[@]} ]
do
    if [ $servico == ${nome[$i]} ]; then 
        if [[ ${names2[$i]} = nio ]]; then
        versao=$(checkVersion.sh $servico $2 | awk -F ' ' '{print $2}')
        elif [[ ${names2[$i]} = ejb ]]; then 
        versao=$(checkVersion.sh $servico e-$2 | awk -F ' ' '{print $2}')
        elif [[ ${names2[$i]} = brms ]]; then
		case $2 in
			uat2|uat3)
				versao=$(checkVersion.sh $servico s-uat | awk -F ' ' '{print $2}');;
			*)
				versao=$(checkVersion.sh $servico s-$2 | awk -F ' ' '{print $2}');;
		esac
        fi
    fi
projeto=$(echo ${ids[$i]})
i=$(( $i + 1 ))
done


ver=( $(curl -s  --header "Authorization: Bearer $token" -X GET https://gitlab.engdb.com.br/api/v4/projects/$projeto/pipelines | jq '.[].ref' |  sed 's/"//g') )
pipeline=( $(curl -s  --header "Authorization: Bearer $token" -X GET https://gitlab.engdb.com.br/api/v4/projects/$projeto/pipelines | jq '.[].web_url' |   sed 's/"//g') )

int=0
if [ "$versao" != naoinstalado ];
    then
        while [ "$int" -lt ${#ver[@]} ]
        do
            if [ "$versao" != "${ver[$int]}" ];
            then
            int=$(( $int + 1 ))
            else 
            break 
            fi
        done
fi

if [ "$versao" != naoinstalado ];
then
echo  "Serviço: $servico | Versão: $versao | Pipeline: ${pipeline[$int]}" 
else
echo "$servico $versao"
fi
cont=$(( $cont + 1 ))