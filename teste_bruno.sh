#!/bin/bash
#Fonte: https://stackoverflow.com/questions/23421917/bash-script-telnet-to-test-multiple-addresses-and-ports

teste=$(cat ips.txt)

echo "$teste" | 
	(
	TCP_TIMEOUT=3
	while read host port; do
		(CURPID=$BASHPID;
		(sleep $TCP_TIMEOUT;kill $CURPID) &
		exec 3<> /dev/tcp/$host/$port
		) 2>/dev/null
		case $? in
			0)
				echo $host $port esta aberta;;
			1)
				echo $host $port esta fechada;;
			143) # killed by SIGTERM
				echo $host $port deu timeout;;
		esac
	done
	) 2>/dev/null 
