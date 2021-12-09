#!/bin/bash
user=$(whoami)

if [ $user == faq1 ]; then
    #WLI UAT1
    ps -ef | grep java | grep fqa1 | grep -v grep | awk -F' ' '{ print $2 }'
    while [ $? -eq 0 ]; do
        kill -9 $(ps -ef | grep java | grep fqa1 | grep -v grep | awk -F' ' '{ print $2 }')
    done
    cd /soa/fqa1/user_projects/domains/IB_FQA1_DOM
    echo -e "\n" | ./startNodeManager.sh && echo -e "\n" | ./startWebLogic.sh
elif [ $user == uat2 ]; then
    #WLI UAT2
    ps -ef | grep java | grep uat2 | grep -v grep | awk -F' ' '{ print $2 }'
    while [ $? -eq 0 ]; do
        kill -9 $(ps -ef | grep java | grep uat2 | grep -v grep | awk -F' ' '{ print $2 }')
    done
    cd /appl/uat2/domains/wli_uat2_domain
    echo -e "\n" | ./startNodeManager.sh && echo -e "\n" | ./startWebLogic.sh
else
    echo "Nao host não é uat1 ou uat2"
fi
