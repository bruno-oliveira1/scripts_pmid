#!/bin/bash

#Esse script tem a função similar ao pmidChange.sh com algumas alterções com a adição de verificar os ambientes de uat 1 2 3 e prd

#Função principal que vai retornar todas versões dos serviços, e que termina antes desse comentario: #Execução do script começa por aqui
pmidchange () {

#Adiciona os serviços retornados ao vetor
concatenar () {
    int=0
    while [ $int -lt ${#pod[@]} ]
    do
    var=("${var[@]}" "$(echo "${pod[$int]}")" )
    int=$(( $int + 1 ))
    done 
}

#Função que retona os serviços dos chamados pelo orch
serviceList () {
    orch=$(echo "$1" | awk '{print tolower($0)}')
    #versaos convencionais
	pod=( $(kubectl exec -it deploy/$orch -n $namespace -- bash -c "grep -i processid resources/*.bpmn" | cut -d \" -f 4 | sed -r 's/[A-Z]/-\L&/g' ) )
    concatenar
    #rules
    pod=( $(kubectl exec -it deploy/$orch -n $namespace -- bash -c "grep -i httpUriTmplInline resources/*.bpmn" 2>/dev/null | grep -s rules | cut -d \/ -f 3 | cut -d \" -f 1 | cut -d \? -f 1 ) )
    concatenar
}

#Função que verifica se é o serviço retornado é um orch e sendo assim chama a função serviceList
loop () {
int=0
while [ $int -lt ${#var[@]} ]
do
echo "${var[$int]}" | grep orch  >/dev/null 2>&1 && serviceList "${var[$int]}" 
int=$(( $int + 1 ))
done
}

serviceList $1
orchp=$(echo $orch)
loop

#Junta o orch principal com os outros serviços retornados anteriormente
var2=( $(echo $orchp) )
int=0
while [ $int -lt ${#var[@]} ]
  do
  var2=("${var2[@]}" "$(echo "${var[$int]}")" )
  int=$(( $int + 1 ))
done 

versao=$(checkVersion.sh $orchp $namespace | awk -F ' ' '{print $2}')
servicos=( $(echo $orchp) )
versoes=( $(echo $versao) )

int=0

#Remove serviços duplicados
var2=( $( echo "${var2[@]}" | tr ' ' '\n' | awk '!x[$0]++' ) )

#Função que adiciona versão e nome do serviços aos vetores
versoeseservicos () {
	versoes=( "${versoes[@]:0:$int}" "$versao" "${versoes[@]:$int}" )
	servicos=( "${servicos[@]:0:$int}" "${var2[$int]}" "${servicos[@]:$int}" )
	printf  "%s:%s\n" ${servicos[$int]} ${versoes[$int]}
}

versoes=( "${versoes[@]:0:$int}" "$versao" "${versoes[@]:$int}" )
printf  "%s:%s\n" ${servicos[$int]} ${versoes[$int]}

int=1

while [ $int -lt ${#var2[@]} ]
do
echo "${var2[$int]}" | grep -i rules && versao=$(checkVersion.sh "${var2[$int]}"-v1 s-$namespace | awk -F ' ' '{print $2}') && versoeseservicos || versao=$(checkVersion.sh "${var2[$int]}" $namespace | awk -F ' ' '{print $2}') && versoeseservicos
int=$(( $int + 1 ))
done
} #Aqui termina a função pmidchange

#Execução do script começa por aqui
if [ -z $1 ]; then
	echo "Nome do servico não informado "
	exit 1
fi

#Troca para o ambiente de prod
changeEnv.sh prd &> /dev/null
namespace=prd
printf "\nPRD \n"
#Chama a função pmidchange passando como parametro o ambiente e o orch informado, guarda o retorno dentro do vetor prd
prd=( $(pmidchange $1 $namespace) ) 

int=0

while [ $int -lt ${#prd[@]} ]
do
printf  "%s %s\n" "${prd[$int]}" | awk -F : '{print $1" "$2}'
int=$(( $int + 1 ))
done

#Troca para o ambiente de fqa
changeEnv.sh fqa &> /dev/null
namespace=uat
printf "\nUAT \n"
#Chama a função pmidchange passando como parametro o ambiente e o orch informado, guarda o retorno dentro do vetor uat
uat=( $(pmidchange $1 $namespace) ) 

int=0

while [ $int -lt ${#uat[@]} ]
do
printf  "%s %s\n" "${uat[$int]}" | awk -F : '{print $1" "$2}'
int=$(( $int + 1 ))
done

namespace=uat2
printf "\nUAT2 \n"
#Chama a função pmidchange passando como parametro o ambiente e o orch informado, guarda o retorno dentro do vetor uat2
uat2=( $(pmidchange $1 $namespace) ) 

int=0

while [ $int -lt ${#uat2[@]} ]
do
printf  "%s %s\n" "${uat2[$int]}" | awk -F : '{print $1" "$2}'
int=$(( $int + 1 ))
done

namespace=uat3
printf "\nUAT3 \n"
#Chama a função pmidchange passando como parametro o ambiente e o orch informado, guarda o retorno dentro do vetor uat3
uat3=( $(pmidchange $1 $namespace) ) 

int=0

while [ $int -lt ${#uat3[@]} ]
do
printf  "%s %s\n" "${uat3[$int]}" | awk -F : '{print $1" "$2}'
int=$(( $int + 1 ))
done

printf "\n"