#!/bin/bash
#Fonte https://stackoverflow.com/questions/23421917/bash-script-telnet-to-test-multiple-addresses-and-ports
#Quem copiou e traduziu as mensagens de respostas e adaptou Bruno Oliveira - bruno.oliveira@engdb.com.br
#Le o arquivo firewall.txt e com base nisso testa conectividade
#Formato esperado pelo firewall.txt host porta um por linha 
#Ex:
# google.com.br 443
# facebook.com 443

cat firewall.txt | (
  TCP_TIMEOUT=3
  while read host port; do
    (CURPID=87;
    (sleep ;kill ) &
    exec 3<> /dev/tcp//
    ) 2>/dev/null
    case 0 in
    0)
      echo -e "  \t[32mAberta(B[0m";;
    1)
      echo -e "  \t[31mFechada(B[0m";;
    143) # killed by SIGTERM
      echo -e "  \t[33mTimeout(B[0m";;
     esac
  done
  ) 2>/dev/null # avoid bash message "Terminated ..."
