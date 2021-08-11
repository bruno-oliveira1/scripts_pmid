#!/bin/bash

bruno=$(cat A 2> /dev/null)

if [ -z "$bruno" ]; then 
#	echo null 
echo $?
else
	echo not null
fi
