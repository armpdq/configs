#!/bin/bash

CONF_URL="http://replace/flussonic.conf?key=some_secret_token"

CONF_FILE="/etc/flussonic/flussonic.conf"
TMP_FILE="/etc/flussonic/flussonic.conf.1"

while true
do
    ## remove tmp conf file
    [ -f $TMP_FILE ] && rm $TMP_FILE

    while [[ "$(curl --max-time 5 -s -o $TMP_FILE -w ''%{http_code}'' $CONF_URL)" != "200" ]]; do 
        echo "CURL failed to download config file, sleep 3 sec"
        sleep 3; 
    done

    a=$(md5sum $CONF_FILE | awk '{print $1}')
    b=$(md5sum $TMP_FILE | awk '{print $1}')

    echo "config downloaded: current_hash=$a new_has=$b"

    if [[ "$a" == "$b" ]]; then
      echo "skip: config doesn't change"
    else
      mv $TMP_FILE $CONF_FILE
      /etc/init.d/flussonic reload
      echo "config replaced & service reloaded"
    fi
    echo "----------------------------------------------------------"

    sleep 3 
done
