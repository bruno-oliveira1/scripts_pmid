#!/bin/bash -x
#
# restartlogstash.sh - .
#
# Histórico de versões:
#       Versão: 1.0
#               Author: Bruno da Silva Oliveira <bruno.oliveira2@engdb.com.br>
#               Date: 2*/07/2021
#               Descrição: Versão inicial.
#

user=$(whoami)

sr_logstash () {
cd $(ls -d /nmws_app/cmd/logstash-* | sort | tail -1)
./stop_logstash.sh
echo ""
echo Stop do logstash feito >> /nmws_app/cmd/teste.log
./restart_logstash.sh &
echo ""
echo Restart do logstash feito >> /nmws_app/cmd/teste.log
}

stop_start_elastic () {
diretorio=$(ls -d /domain/ELK/elastic/elasticsearch-* | sort | tail -1)
binario=$(echo $diretorio/bin/elasticsearch)
processo=`ps -ef | grep $diretorio | grep -v grep | awk '{print $2}'`
for line in $processo
do
        kill -9 $line
done

processo=`ps -ef | grep $diretorio | grep -v grep | awk '{print $2}'`
if [ "$processo" == "" ];
then
        $binario -d -p $diretorio/pid
else
        for line in $processo
        do
                kill -9 $line
        done

        sleep 5

        $binario -d -p $diretorio/pid
fi
}

sr_elastic () {
stop_start_elastic
sleep 120
curl -XPUT -H "Content-Type: application/json" http://snelnxr70:9200/_all/_settings -d '{"index.blocks.read_only_allow_delete": false}' >> $diretorio/logs/teste.log
curl -XPUT -H "Content-Type: application/json" http://snelnxr70:9200/*/_settings -d '{"index.blocks.read_only_allow_delete": false}' >> $diretorio/logs/teste.log
echo curl executado >> $diretorio/logs/teste.log
}

case $user in
elastic)
sr_elastic
;;
nmws_app)
sr_logstash
;;
*)
echo "Usuario diferente do esperado"
;;
esac