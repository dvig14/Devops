 #!/bin/bash 
 
 function err_log(){
    
    local LOGDIR="../logs"
    local LOGFILE="$LOGDIR/error.log"	 
    
    if [ ! -d "$LOGDIR" ]; then 
       mkdir -p "$LOGDIR"
       echo "$(date '+%Y-%m-%d %H:%M:%S') - INFO: Log directory created: $LOGDIR" >> "$LOGFILE"
    fi

    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $1" >> "$LOGFILE"
 }

