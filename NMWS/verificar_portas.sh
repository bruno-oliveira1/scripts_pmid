#!/bin/bash
#Fonte https://stackoverflow.com/questions/23421917/bash-script-telnet-to-test-multiple-addresses-and-ports
#Quem copiou e traduziu as mensagens de respostas e adaptou Bruno Oliveira - bruno.oliveira@engdb.com.br
#Le o arquivo firewall.txt e com base nisso testa conectividade
#Formato esperado pelo firewall.txt host porta um por linha
#Ex:
# google.com.br 443
# facebook.com 443

case $1 in 
-u)
  execucao="echo $2 $3"
  ;;
-p)
  execucao="cat $2"
  ;;
-a)
  execucao="cat $HOME/firewall.txt"
  ;;
*)
echo "Parametro nao informado"
esac

$execucao | (
  TCP_TIMEOUT=3
  while read host port; do
    (CURPID=$BASHPID;
    (sleep $TCP_TIMEOUT;kill $CURPID) &
    exec 3<> /dev/tcp/$host/$port
    ) 2>/dev/null
    case $? in
    0)
      echo -e "${host} ${port} Aberta";;
    1)
      echo -e "$host $port Fechada";;
    143) # killed by SIGTERM
       echo -e "$host $port Timeout";;
     esac
  done
  ) 2>/dev/null