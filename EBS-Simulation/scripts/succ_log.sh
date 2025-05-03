#!/bin/bash

 function succ_log(){
    
    local LOGDIR="../logs"
    local LOGFILE="$LOGDIR/success.log"

    if [ ! -d "$LOGDIR" ]; then
       mkdir -p "$LOGDIR"
       echo "$(date '+%Y-%m-%d %H:%M:%S') - INFO: Log directory created: $LOGDIR" >> "$LOGFILE"
    fi

    echo "$(date '+%Y-%m-%d %H:%M:%S') - SUCCESS: $1" >> "$LOGFILE"
 }

