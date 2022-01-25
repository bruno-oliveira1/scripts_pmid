#!/bin/bash
PATH="/appl/oracle/jdks/jdk1.6/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/sbin:/infobus/uat1/bin:.:/infobus/uat1/cmd:/ora10gCL/product/10.2.0/bin:/sbin"
dia=$(date +%Y_%m_%d)
log=/infobus/uat1/cmd/logs/"$dia"_manage_console.log
logs=/infobus/uat1/cmd/logs
temp=/tmp/status_consoles.temp

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

#Mostrar status dos nods
stop () {
$wlst <<EOF 1>&- 2>&- &
connect("$usuario","${senhas[$int]}","t3://${servidores[$int]}")
shutdown('${instacias[$cont]}','Server',ignoreSessions='true',force='true')
exit()
EOF
}

#Inicia os nods
start () {
$wlst <<EOF 1>&- 2>&- &
connect("$usuario","${senhas[$int]}","t3://${servidores[$int]}")
start('${instacias[$cont]}','Server',block="true")
exit()
EOF
}

#Resume os nods
resume () {
$wlst <<EOF 1>&- 2>&- &
connect("$usuario","${senhas[$int]}","t3://${servidores[$int]}")
resume('${instacias[$cont]}',block="true")
exit()
EOF
}

#Recupera os nods
nod () {
nod=$("$wlst" <<EOF &
connect("$usuario","${senhas[$int]}","t3://${servidores[$int]}")
ls('Servers',returnMap='true')
exit()
EOF )
instacias=( $(awk -F '>' '{print $3}'  <<< $nod | awk -F 'wls' '{print $1}' | sed -e 's/ dr--//g' -e "s/ /\n/g" | sed -e 's/^.*adm//gI' -e 's/bam_uat1_01//gI' -e 's/^.*IB_FQA1_NOD2//g' -e 's/^.*IB_FQA1_NOD03//g' |  sed '/^$/d' ) )
}

#Verifica status dos nods para ver se tem algum como ADMIN
mostrarstatus1 () {
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
    echo "No servidor "${servidores[$int]}" o nod "${instacias[$cont]}" está "$estado"  ">> "$temp"

    cont=$(( $cont + 1 ))
    done

    #Incrementa 1 a int
        int=$(( $int + 1 ))
done
}

#Verifica status dos nods para ver se tem algum como ADMIN
mostrarstatus2 () {
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
    echo "No servidor "${servidores[$int]}" o nod "${instacias[$cont]}" está "$estado "" >> "$log"

    cont=$(( $cont + 1 ))
    done

    #Incrementa 1 a int
        int=$(( $int + 1 ))
done
}

#Verifica se o status do nod esta em ADMIN e resume os nods
verificastatus () {
servidor=( $(grep servidor log.txt | grep -v RUNNING | awk '{print $3}') )
instacias=( $(grep servidor log.txt | grep -v RUNNING | awk '{print $6}') )
estado=( $(grep servidor log.txt | grep -v RUNNING | awk '{print $8}') )

int=0
cont=0
while [ $int -lt ${#servidores[@]} ]
do
   if [ "${servidores[$int]}" = "${servidor[$cont]}" ]; then
        case ${estado[$cont]} in
            ADMIN)
                resume
                    ;; 
            *)
                start
        esac
        cont=$(( $cont + 1 ))
   fi
   int=$(( $int + 1 ))
done
sleep 120
kill -9 `ps -ef | grep -i wlst.sh | grep -v grep | awk '{print $2 }'`
rm -rf $temp
find $logs -name "*manage*" -type f -mtime +30 -delete
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

echo "Exibindo servidores e nods" >> "$log"
#Compara se o valor de int é menor que o de quantidade e se for executa o a condição abaixo senão for encerra a execução do script
while [ $int -lt ${#servidores[@]} ]
do
nod
        #echo "O servidor "${servidores[$int]}" tem os nos "${instacias[@]}""
    cont=0
    while [ $cont -lt ${#instacias[@]} ]
    do
    echo "Servidor "${servidores[$int]}" nod "${instacias[$cont]}" " >> "$log"
    cont=$(( $cont + 1 ))
    done
        echo
    #Incrementa 1 a int
        int=$(( $int + 1 ))
done
}

tipot () {
#Servidores - Todos
servidores=("snelnx757:10000" "snelnx757:20000" "snelnx757:30000" "snelnx755:10000" "snelnx755:20000" "snelnx755:30000" "snehpub6:10070" "snelnx185:20000" "snelnxa139:4000" "snelnxa142:4000" "snelnxa142:5500" "snelnxa138:7000" "snelnxa141:7000" "snelnxe92:10000" "snelnxe96:10000" "snelnxe93:20000" "snelnxe97:20000" "snelnxe93:30000" )
#Senhas - Todos
senhas=("weblogic" "weblogic" "weblogic" "weblogic1" "weblogic1" "weblogic1" "fqa1#WLI" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" "weblogic1" )
}

tipop () {
#Servidores - Parcial
servidores=("snelnx755:10000" "snelnx755:20000" "snelnx755:30000" "snehpub6:10070" "snelnx185:20000" "snelnxa139:4000" "snelnxa142:4000" )
#Senhas - Parcial
senhas=("weblogic1" "weblogic1" "weblogic1" "fqa1#WLI" "weblogic1" "weblogic1" "weblogic1" )
}

reinicio () {
            > "$log"
            echo "Inicio $(date +%H:%M:%S_%d_%m_%Y)" >> "$log"
            pararnods
            echo "Parando nods $(date +%H:%M:%S_%d_%m_%Y)" >> "$log"
            sleep 180
            iniciarnods
            echo "Iniciando nods $(date +%H:%M:%S_%d_%m_%Y)" >> "$log"
            sleep 360
            resumirnods
            echo "Resumindo nods $(date +%H:%M:%S_%d_%m_%Y)" >> "$log"
            sleep 180
            echo "Mostrando status dos nods $(date +%H:%M:%S_%d_%m_%Y)" >> "$log"
            mostrarstatus1
            verificastatus
            mostrarstatus2
            cd /appl/oracle/Oracle/Middleware/logs
            find . -maxdepth 1 -name "wlst_*.*" -print0 | xargs -0 rm
            echo "Fim $(date +%H:%M:%S_%d_%m_%Y)" >> "$log"
            kill -9 `ps -ef | grep weblogic.WLST | grep -v grep | awk '{print $2}'` 2> /dev/null
            kill -9 `ps -ef | grep wlst.sh | grep -v grep | awk '{print $2}'` 2> /dev/null
            #telegram.sh "$log"

}

usuario="system"
wlst="/appl/oracle/Oracle/Middleware/wlserver_10.3/common/bin/wlst.sh"
diadasemana=$(date '+%u')

case "$diadasemana" in
                1|5)
        execucao=todos
        #execucao=listar
        echo "Todos $(date +%H:%M:%S_%d_%m_%Y)" >> "$log"
        ;;
                2|3|4)
        execucao=parcial
        echo "Parcial $(date +%H:%M:%S_%d_%m_%Y)" >> "$log"
        ;;
                *)
        exit 1
esac

case "$execucao" in
                todos)
            tipot
            reinicio
            ;;
                parcial)
            tipop
            reinicio
            ;;
                status)
            tipot
            mostrarstatus1
            ;;
                statusp)
            tipoc
            mostrarstatus1
            ;;
                listar)
            tipot
            mostrarnod
            ;;
                listarp)
            tipop
            mostrarnod
            ;;

               *|help|--help|-h|ajuda|socorro)
                        echo -e "Uso: \n manage_consoles.sh todos ou manage_consoles.sh c para fazer restart de todos os nods das consoles (segundas e sextas)"
            echo " manage_consoles.sh parcial ou manage_consoles.sh p para fazer restart parcial das consoles (terças quartas quintas)"
            echo " manage_consoles.sh status para ver status de todas as consoles"
            echo " manage_consoles.sh statusp para ver status das consoles de terca quarta quintas"
            echo " "
esac