#!/bin/bash

# Checks to see if the icecast server has the mountpoint and if not restarts Darkice

url="http://wxradio.dyndns.org:8000"
status_code=$(curl -v  $url 2>&1 | grep -o /mycity/mycallsign.mp3)
#echo "$status_code"

if [ "$status_code" == "" ]
then
    sudo /usr/sbin/service darkice restart
fi
