#!/bin/bash
#
# ibrestart.sh - Identifica em qual ambiente está sendo executado e se for UAT1 e UAT2
# e faz o restart e visualiza o log IBJ2EERouter_perfmon do dia de hoje, se identificar que é UAT3 só visualiza o log.
#
# Histórico de versões:
#       Versão: 1.0
#               Author: Bruno da Silva Oliveira <bruno.oliveira2@engdb.com.br>
#               Date: 22/07/2021
#               Descrição: Versão inicial.
#

stopstart () {
	spgStop
	spgStart
	sleep 5
}

verlog () {
	tail -1000 IBJ2EERouter_perfmon_$(date +%Y%m%d).log
}

sucesso () {
	echo ""
	echo "Log visualizado IBJ2EERouter_perfmon_$(date +%Y%m%d).log"
	echo ""
	echo "Agora ficou mais fácil esse trabalho chato tenha um bom dia"
	echo $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84' $'\xF0\x9F\x98\x84'
}


user=$(whoami)
echo "$user"

case $user in
	uat1)
		stopstart
		cd /infobus_log/uat1/logs/j2eeadpt || echo "Diretorio nao existe"
		verlog
		sucesso
		;;

	uat2)
		stopstart
		cd /infobus_log/uat2/logs/j2eeadpt || echo "Diretorio nao existe"
		verlog
		sucesso
		;;

	uat3)
		cd /infobus/uat3/log/j2eeadpt || echo "Diretorio nao existe"
		verlog
		sucesso
		;;

	*)
		echo "Erro, esse ambiente é mesmo ib ?"
		echo  $'\xF0\x9F\x98\x93'
		exit
esac
