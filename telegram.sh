#!/bin/bash
TOKEN=2111670512:AAFKo_0JeJRhiJFEClui0d11YA57su87tnY
CHAT_ID=-766839493
#MESSAGE="Alô Mundo!"
MESSAGE=$(cat $1)
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$MESSAGE"
