#!/bin/bash

status () {
estado=$("$wlst" << EOF
connect("$usuario","${senhas[$int]}","t3://${servidores[$int]}")
state('${instacias[$cont]}')
EOF )
estado=$(grep -o 'FAILED_NOT_RESTARTABLE\|UNKNOWN\|SHUTDOWN\|RUNNING\|ADMIN' <<< $estado)
}

nod () {
nod=$("$wlst" << EOF
connect("$usuario","${senhas[$int]}","t3://${servidores[$int]}")
ls('Servers',returnMap='true')
EOF
)
instacias=( $(awk -F '>' '{print $3}'  <<< $nod | awk -F 'wls' '{print $1}' | sed -e 's/ dr--//g' -e "s/ /\n/g" | sed -e 's/^.*adm//gI' -e 's/bam_uat1_01//gI' -e 's/^.*IB_FQA1_NOD2//g' -e 's/^.*IB_FQA1_NOD03//g' |  sed '/^$/d' ) ) 
}

usuario="system"
wlst=$BEA_HOME/common/bin/wlst.sh

if [ $1 == completo ]; then
#Servidores - Restart Completo
servidores=("snelnx757:10000" "snelnx757:20000" "snelnx757:30000" "snelnx755:10000" "snelnx755:20000" "snelnx755:30000" "snehpub6:10070" "snelnx185:20000" "snelnxa139:4000" "snelnxa142:4000" "snelnxa142:5500" "snelnxa138:7000" "snelnxa141:7000" "snelnxe92:10000" "snelnxe96:10000" "snelnxe93:20000" "snelnxe97:20000" "snelnxe93:30000" )
#Senhas - Restart Completo
senhas=("weblogic" "weblogic" "weblogic" "weblogic1" "weblogic1" "weblogic1" "fqa1#WLI" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" )
elif [ $1 == parcial ]; then
#Servidores - Restart Parcial
servidores=("snelnx755:10000" "snelnx755:20000" "snelnx755:30000" "snehpub6:10070" "snelnx185:20000" "snelnxa139:4000" "snelnxa142:4000" )
#Senhas - Restart Parcial
senhas=("weblogic1" "weblogic1" "weblogic1" "fqa1#WLI" "weblogic1" "weblogic1" "weblogic1" )
else 
echo "Eh preciso selecionar o tipo de restart completo ou parcial\n Ex: restart_proxys.sh completo"
#Variável de contador
int=0

#Compara se o valor de int é menor que o de quantidade e se for executa o a condição abaixo senão for encerra a execução do script 
while [ $int -lt ${#servidores[@]} ]
do
nod
	#echo "O servidor "${servidores[$int]}" tem os nos "${instacias[@]}"" 
    cont=0
    while [ $cont -lt ${#instacias[@]} ]
    do
    status
    echo "No servidor "${servidores[$int]}" o nod "${instacias[$cont]}" está "$estado" "
    cont=$(( $cont + 1 ))
    done
    
    #Incrementa 1 a int 
	int=$(( $int + 1 ))
done