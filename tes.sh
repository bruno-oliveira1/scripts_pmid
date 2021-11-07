#!/bin/bash
u=$( cmd.exe /c echo %HOMEPATH%  | cut -d\\ -f3)
d=$(awk '{ sub("\r$", ""); print }' <<< $u)

cp a /mnt/c/Users/$d/Desktop/
