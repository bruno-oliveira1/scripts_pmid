#!/bin/bash

#Funções 

#Verifica status do nod
status () {
estado=$("$wlst" <<EOF &
connect("$usuario","${senhas[$int]}","t3://${servidores[$int]}")
state('${instacias[$cont]}')
exit()
EOF
)
estado=$(grep -o 'FAILED_NOT_RESTARTABLE\|UNKNOWN\|SHUTDOWN\|RUNNING\|ADMIN' <<< $estado)
}

#
stop () {
$wlst <<EOF 1>&- 2>&- &
connect("$usuario","${senhas[$int]}","t3://${servidores[$int]}")
shutdown('${instacias[$cont]}','Server',ignoreSessions='true',force='true')
exit()
EOF
}

start () {
$wlst <<EOF 1>&- 2>&- &
connect("$usuario","${senhas[$int]}","t3://${servidores[$int]}")
start('${instacias[$cont]}','Server',block="true")
exit()
EOF
}

resume () {
$wlst <<EOF 1>&- 2>&- &
connect("$usuario","${senhas[$int]}","t3://${servidores[$int]}")
resume('${instacias[$cont]}',block="true")
exit()
EOF
}

nod () {
nod=$("$wlst" <<EOF &
connect("$usuario","${senhas[$int]}","t3://${servidores[$int]}")
ls('Servers',returnMap='true')
exit()
EOF )
instacias=( $(awk -F '>' '{print $3}'  <<< $nod | awk -F 'wls' '{print $1}' | sed -e 's/ dr--//g' -e "s/ /\n/g" | sed -e 's/^.*adm//gI' -e 's/bam_uat1_01//gI' -e 's/^.*IB_FQA1_NOD2//g' -e 's/^.*IB_FQA1_NOD03//g' |  sed '/^$/d' ) ) 
}

mostrarstatus () {
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
}

pararnods () {

ssh fqa1@snehpub6 /soa/fqa1/cmd/reiniciar_weblogic.sh 1>&- 2>&- &
ssh uat2@snelnx185 /appl/uat2/cmd/reiniciar_weblogic.sh 1>&- 2>&- &

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
    stop
    cont=$(( $cont + 1 ))
    done
    
    #Incrementa 1 a int 
	int=$(( $int + 1 ))
done
}

iniciarnods () {
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
    start
    cont=$(( $cont + 1 ))
    done
    
    #Incrementa 1 a int 
	int=$(( $int + 1 ))
done
}

resumirnods () {
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
    resume
    cont=$(( $cont + 1 ))
    done
    
    #Incrementa 1 a int 
	int=$(( $int + 1 ))
done
}

mostrarnod () {
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
    echo "Servidor "${servidores[$int]}" nod "${instacias[$cont]}" "
    cont=$(( $cont + 1 ))
    done
    
    #Incrementa 1 a int 
	int=$(( $int + 1 ))
done
}

usuario="system"
wlst=$BEA_HOME/common/bin/wlst.sh

case $1 in
		completo) 
            #Servidores - Completo
            servidores=("snelnx757:10000" "snelnx757:20000" "snelnx757:30000" "snelnx755:10000" "snelnx755:20000" "snelnx755:30000" "snehpub6:10070" "snelnx185:20000" "snelnxa139:4000" "snelnxa142:4000" "snelnxa142:5500" "snelnxa138:7000" "snelnxa141:7000" "snelnxe92:10000" "snelnxe96:10000" "snelnxe93:20000" "snelnxe97:20000" "snelnxe93:30000" )
            #Senhas - Completo
            senhas=("weblogic" "weblogic" "weblogic" "weblogic1" "weblogic1" "weblogic1" "fqa1#WLI" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" )
            pararnods
            sleep 120
            iniciarnods
            sleep 300
            resumirnods
            sleep 120
            mostrarstatus
            ;;
		parcial) 
            #Servidores - Parcial
            servidores=("snelnx755:10000" "snelnx755:20000" "snelnx755:30000" "snehpub6:10070" "snelnx185:20000" "snelnxa139:4000" "snelnxa142:4000" )
            #Senhas - Parcial
            senhas=("weblogic1" "weblogic1" "weblogic1" "fqa1#WLI" "weblogic1" "weblogic1" "weblogic1" )
            pararnods
            sleep 120
            iniciarnods
            sleep 300
            resumirnods
            sleep 120
            mostrarstatus
			;;
		status) 
			#Servidores - Completo
            servidores=("snelnx757:10000" "snelnx757:20000" "snelnx757:30000" "snelnx755:10000" "snelnx755:20000" "snelnx755:30000" "snehpub6:10070" "snelnx185:20000" "snelnxa139:4000" "snelnxa142:4000" "snelnxa142:5500" "snelnxa138:7000" "snelnxa141:7000" "snelnxe92:10000" "snelnxe96:10000" "snelnxe93:20000" "snelnxe97:20000" "snelnxe93:30000" )
            #Senhas - Completo
            senhas=("weblogic" "weblogic" "weblogic" "weblogic1" "weblogic1" "weblogic1" "fqa1#WLI" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" )
			mostrarstatus
            ;;
		statusp)
			#Servidores - Parcial
            servidores=("snelnx755:10000" "snelnx755:20000" "snelnx755:30000" "snehpub6:10070" "snelnx185:20000" "snelnxa139:4000" "snelnxa142:4000" )
            #Senhas - Parcial
            senhas=("weblogic1" "weblogic1" "weblogic1" "fqa1#WLI" "weblogic1" "weblogic1" "weblogic1" )
			mostrarstatus
            ;;
		listar)
        	#Servidores - Completo
            servidores=("snelnx757:10000" "snelnx757:20000" "snelnx757:30000" "snelnx755:10000" "snelnx755:20000" "snelnx755:30000" "snehpub6:10070" "snelnx185:20000" "snelnxa139:4000" "snelnxa142:4000" "snelnxa142:5500" "snelnxa138:7000" "snelnxa141:7000" "snelnxe92:10000" "snelnxe96:10000" "snelnxe93:20000" "snelnxe97:20000" "snelnxe93:30000" )
            #Senhas - Completo
            senhas=("weblogic" "weblogic" "weblogic" "weblogic1" "weblogic1" "weblogic1" "fqa1#WLI" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" )
            mostrarnod
        ;;
        listarp)
        	#Servidores - Parcial
            servidores=("snelnx757:10000" "snelnx757:20000" "snelnx757:30000" "snelnx755:10000" "snelnx755:20000" "snelnx755:30000" "snehpub6:10070" "snelnx185:20000" "snelnxa139:4000" "snelnxa142:4000" "snelnxa142:5500" "snelnxa138:7000" "snelnxa141:7000" "snelnxe92:10000" "snelnxe96:10000" "snelnxe93:20000" "snelnxe97:20000" "snelnxe93:30000" )
            #Senhas - Parcial
            senhas=("weblogic" "weblogic" "weblogic" "weblogic1" "weblogic1" "weblogic1" "fqa1#WLI" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" )
            mostrarnod
        ;;
        teste)
        	#Servidores - teste
            servidores=("snelnx755:10000" "snelnx755:20000" )
            #Senhas - teste
            senhas=("weblogic1" "weblogic1")
            #mostrarstatus
            pararnods
            sleep 120
            mostrarstatus
            sleep 60
            iniciarnods
            sleep 300
            mostrarstatus
            sleep 60
            resumirnods
            sleep 120
            mostrarstatus
        ;;

		*|help|--help|-h|ajuda|socorro)
			echo -e "Uso: \n manage_consoles.sh completo ou manage_consoles.sh c para fazer restart de todas as consoles (segundas e sextas)" 
            echo " manage_consoles.sh parcial ou manage_consoles.sh p para fazer restart parcial das consoles (terças quartas quintas)"
            echo " " 
	esac