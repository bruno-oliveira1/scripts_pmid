#!/bin/bash
PATH="/opt/pivotal/java/bin:/opt/pivotal/timgfg/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"
dia=$(date +%Y_%m_%d)
log="$dia"_restart_imdb.log
logs=/tcserver/logs/
tcruntime=/opt/pivotal/timgfg8/bin/tcruntime-ctl.sh


#UAT1
#Parar TCSERVER na tcserver@rjolnxa77
/opt/pivotal/timgfg8/bin/tcruntime-ctl.sh stop 1>&- 2>&- &

#Parar TCSERVER na tcserver@rjolnxa78
ssh tcserver@rjolnxa78 /opt/pivotal/timgfg8/bin/tcruntime-ctl.sh stop 1>&- 2>&- &

#Parar IMDB
ssh gemfire@rjolnxa71 /gemfire/pivotal/scripts/ds001/bin/stop-servers.sh 1>&- 2>&- &
ssh gemfire@rjolnxa72 /gemfire/pivotal/scripts/ds001/bin/stop-servers.sh 1>&- 2>&- &
ssh gemfire@rjolnxa73 /gemfire/pivotal/scripts/ds001/bin/stop-servers.sh 1>&- 2>&- &
ssh gemfire@rjolnxa74 /gemfire/pivotal/scripts/ds001/bin/stop-servers.sh 1>&- 2>&- &

#Iniciar IMDB
ssh gemfire@rjolnxa71 /gemfire/pivotal/scripts/ds001/bin/start-server-1.sh 1>&- 2>&- &
ssh gemfire@rjolnxa72 /gemfire/pivotal/scripts/ds001/bin/start-server-1.sh 1>&- 2>&- &
ssh gemfire@rjolnxa73 /gemfire/pivotal/scripts/ds001/bin/start-server-1.sh 1>&- 2>&- &
ssh gemfire@rjolnxa74 /gemfire/pivotal/scripts/ds001/bin/start-server-1.sh 1>&- 2>&- &

#Iniciar TCSERVER na tcserver@rjolnxa77
/opt/pivotal/timgfg8/bin/tcruntime-ctl.sh start 1>&- 2>&- &

#Iniciar TCSERVER na tcserver@rjolnxa78
ssh tcserver@rjolnxa78 /opt/pivotal/timgfg8/bin/tcruntime-ctl.sh start 1>&- 2>&- &

#UAT2
#Parar TCSERVER na tcserver@rjolnxa77
/opt/pivotal/timgfg8_fqa3/bin/tcruntime-ctl.sh 1>&- 2>&- &

#Parar TCSERVER na tcserver@rjolnxa78
ssh tcserver@rjolnxa78 /opt/pivotal/timgfg8_fqa3/bin/tcruntime-ctl.sh 1>&- 2>&- &

#Parar IMDB
ssh gemfire@rjolnxa71 /gemfire/pivotal/scripts/ds007/bin/stop-servers.sh 1>&- 2>&- &
ssh gemfire@rjolnxa72 /gemfire/pivotal/scripts/ds007/bin/stop-servers.sh 1>&- 2>&- &
ssh gemfire@rjolnxa73 /gemfire/pivotal/scripts/ds007/bin/stop-servers.sh 1>&- 2>&- &
ssh gemfire@rjolnxa74 /gemfire/pivotal/scripts/ds007/bin/stop-servers.sh 1>&- 2>&- &

#Iniciar IMDB
ssh gemfire@rjolnxa71 /gemfire/pivotal/scripts/ds007/bin/start-server-1.sh 1>&- 2>&- &
ssh gemfire@rjolnxa72 /gemfire/pivotal/scripts/ds007/bin/start-server-1.sh 1>&- 2>&- &
ssh gemfire@rjolnxa73 /gemfire/pivotal/scripts/ds007/bin/start-server-1.sh 1>&- 2>&- &
ssh gemfire@rjolnxa74 /gemfire/pivotal/scripts/ds007/bin/start-server-1.sh 1>&- 2>&- &

#Iniciar TCSERVER na tcserver@rjolnxa77
/opt/pivotal/timgfg8_fqa3/bin/tcruntime-ctl.sh start 1>&- 2>&- &

#Iniciar TCSERVER na tcserver@rjolnxa78
ssh tcserver@rjolnxa78 /opt/pivotal/timgfg8_fqa3/bin/tcruntime-ctl.sh start 1>&- 2>&- &

#UAT3
#Parar TCSERVER na tcserver@rjolnxf318
ssh tcserver@rjolnxf318 /opt/pivotal/timgfg8/bin/tcruntime-ctl.sh stop 1>&- 2>&- &

#Parar TCSERVER na tcserver@rjolnxf319
ssh tcserver@rjolnxf319 /opt/pivotal/timgfg8/bin/tcruntime-ctl.sh stop 1>&- 2>&- &

#Parar IMDB
ssh gemfire@rjolnxf399 /gemfire/pivotal/scripts/ds001/bin/stop-servers.sh 1>&- 2>&- &
ssh gemfire@rjolnxf400 /gemfire/pivotal/scripts/ds001/bin/stop-servers.sh 1>&- 2>&- &

#Iniciar IMDB
ssh gemfire@rjolnxf399 /gemfire/pivotal/scripts/ds001/bin/start-server-1.sh 1>&- 2>&- &
ssh gemfire@rjolnxf400 /gemfire/pivotal/scripts/ds001/bin/start-server-1.sh 1>&- 2>&- &

#Iniciar TCSERVER na tcserver@rjolnxf318
ssh tcserver@rjolnxf318 /opt/pivotal/timgfg8/bin/tcruntime-ctl.sh start 1>&- 2>&- &

#Iniciar TCSERVER na tcserver@rjolnxf319
ssh tcserver@rjolnxf319 /opt/pivotal/timgfg8/bin/tcruntime-ctl.sh start 1>&- 2>&- &