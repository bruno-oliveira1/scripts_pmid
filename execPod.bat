@ECHO OFF
set /p np=<namespace.txt
kubectl -n %np% exec -it deploy/%1 /bin/bash
