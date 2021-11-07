#!/bin/bash
PATH=/domain/ELK/elastic/jdk1.8.0_121/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/sbin:/domain/ELK/elastic/bin:/domain/ELK/elastic/cmd:/sbin
#
# restartlogstash.sh - .
#
# Histórico de versões:
#       Versão: 1.0
#               Author: Bruno da Silva Oliveira <bruno.oliveira2@engdb.com.br>
#               Date: XX/XX/2021
#               Descrição: Versão inicial.
#

diretorio=$(ls -d /domain/ELK/elastic/elasticsearch-* | sort | tail -1)
dia=$(date "+%Y-%m-%d_%H-%M")
log=${diretorio}/logs/teste.log

stop_elastic () {
cd $diretorio
echo "" >> $log
echo $dia >> $log
kill -9 `ps -ef | grep elasticsearch | grep -v grep |awk '{print $2}'`
pkill -F pid
echo "Elasticsearch finalizado" >> $log
sleep 5
}

start_elastic () {
bin/elasticsearch -d -p pid && echo "Elasticsearch iniciado" >> $log
sleep 60
curl -XPUT -H "Content-Type: application/json" http://snelnxr70:9200/_all/_settings -d '{"index.blocks.read_only_allow_delete": false}' >> $log
curl -XPUT -H "Content-Type: application/json" http://snelnxr70:9200/*/_settings -d '{"index.blocks.read_only_allow_delete": false}' >> $log
echo curl executado >> $log
echo "" >> $log
}

stop_elastic
start_elastic
