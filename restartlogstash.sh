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

sr_elastic () {
cd $(ls -d /domain/ELK/elastic/elasticsearch-* | sort | tail -1)
./stop_elastic.sh
echo ""
echo Stop do elastic feito >> /domain/ELK/elastic/cmd/teste.log
./restart_elastic.sh &
echo ""
echo Restart do elastic feito >> /domain/ELK/elastic/cmd/teste.log
sleep 120
#curl -XPUT -H "Content-Type: application/json" http://snelnxr70:9200/_all/_settings -d '{"index.blocks.read_only_allow_delete": false}' >> /domain/ELK/elastic/cmd/teste.log
curl -XPUT -H "Content-Type: application/json" http://snelnxr70:9200/*/_settings -d '{"index.blocks.read_only_allow_delete": false}' >> /domain/ELK/elastic/cmd/teste.log
echo curl executado >> /domain/ELK/elastic/cmd/teste.log
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
