
#!/bin/bash
#               Autor: Bruno da Silva Oliveira <bruno.oliveira2@engdb.com.br>
#               Date: 24/09/2021
#               Descrição: Versão inicial versão modificada do viewAdapters.sh para ser usando em conjunto com o script todosadapters.sh

packageName=$1

adapter=$(ls /nmws_app/nmws26/repository/resources/adapters/adapters_app_*$packageName.xml 2> /dev/null | tail -1)

for clService in `grep "<cl\_*" $adapter | grep -v clientId | awk -F '<' '{print $2}' | sed "s|>||g"`
do
        service= sed 's/cl_//' <<< $clService

        for tagName in `sed -n "/<$clService>/,/<\/$clService>/p" $adapter | grep -v $clService | awk -F '>' '{print $1}' | sed 's|<||g'`
        do
                tagValue=`sed -n "/<$clService>/,/<\/$clService>/p" $adapter | grep -oP "(?<=$tagName>)[^<]+" | sort -u`

                case $tagName in
                        hostName|hostname)
                                hostValue=`sed -n "/<$clService>/,/<\/$clService>/p" $adapter | grep -oP "(?<=$tagName>)[^<]+" | sort -u`
                                ;;
                        hostPort|port)
                                portValue=`sed -n "/<$clService>/,/<\/$clService>/p" $adapter | grep -oP "(?<=$tagName>)[^<]+" | sort -u`
                                ;;
                        Service_URI)
                                uriValue=`sed -n "/<$clService>/,/<\/$clService>/p" $adapter | grep -oP "(?<=$tagName>)[^<]+" | sort -u`
                                ;;
                        servicename)
                                svcValue=`sed -n "/<$clService>/,/<\/$clService>/p" $adapter | grep -oP "(?<=$tagName>)[^<]+" | sort -u`
                                ;;
                        username)
                                userValue=`sed -n "/<$clService>/,/<\/$clService>/p" $adapter | grep -oP "(?<=$tagName>)[^<]+" | sort -u`
                                ;;
                        password)
                                passValue=`sed -n "/<$clService>/,/<\/$clService>/p" $adapter | grep -oP "(?<=$tagName>)[^<]+" | sort -u`
                                ;;
                esac
        done

        mwAdapter=`sed -n "/<$clService>/,/<\/$clService>/p" $adapter | grep -oP "(?<=middlewareAdapter>)[^<]+" | sort -u`
        https=`sed -n "/<$clService>/,/<\/$clService>/p" $adapter | grep -oP "(?<=https>)[^<]+" | sort -u`
        case $mwAdapter in
                cl_Http*|cl_Crivo)
                        if [ "$https" == "true" ];
                        then
                        echo -n $service && echo -n " " && echo -e "Endpoint: https://$hostValue:$portValue$uriValue"
                        else
                        echo -n $service && echo -n " " && echo -e "Endpoint: http://$hostValue:$portValue$uriValue"
                        fi
                        ;;
                cl_Tcp)
                        echo -n $service && echo -n " " && echo -e "Endpoint: tcp://$hostValue:$portValue"
                        ;;
                cl_OracleDB)
                        echo -n $service && echo -n " " && echo -e "Endpoint: jdbc:oracle:thin:@$hostValue:$portValue:$svcValue"
                        ;;
                cl_RabbitMQ)
                        echo -n $service && echo -n " " && echo -e "Endpoint: amqp://$userValue:$passValue@$hostValue:$portValue"
                        ;;
        esac
done
