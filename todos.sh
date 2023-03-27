#!/bin/bash
$HOME/scripts/changeEnv.sh fqa
$HOME/scripts/todosapontamentos.sh uat &
$HOME/scripts/todosapontamentos.sh uat2 &
$HOME/scripts/todosapontamentos.sh uat3 &
