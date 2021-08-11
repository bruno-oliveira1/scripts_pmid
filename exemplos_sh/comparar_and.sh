#!/bin/bash

# bruno@ENGNB002798

#hostname=$(hostname)
hostname=1
#user=$(whoami)
user=2

if [ "$hostname" == ENGNB002798 ] && [ "$user" == bruno  ]; then
	        echo "$hostname"'@'"$user"
	elif [ "$hostname" == 1 ] && [ "$user" == bruno  ]; then
		echo sim
	else
		echo nao
	fi

