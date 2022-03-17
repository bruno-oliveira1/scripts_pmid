#!/bin/bash
#Fonte: https://stackoverflow.com/questions/23421917/bash-script-telnet-to-test-multiple-addresses-and-ports
##Quem copiou e traduziu as mensagens de respostas e adaptou Bruno Oliveira - bruno.oliveira@engdb.com.br

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
*|help|--help)
echo "Como usar"
echo "-a lê os ips e portas que estão no arquivo $HOME/firewall.txt - Ex: verificar_portas.sh -a"
echo "-p lê os ips e portas que estão no arquivo que vc informar o caminho - Ex: verificar_portas.sh -p /tmp/lista"
echo "-u executa com host e porta únicos - Ex: verificar_portas.sh -u google.com 443"
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