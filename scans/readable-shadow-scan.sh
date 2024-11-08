#! bin bash

EXPLOIT=1       # Determines whether user wants to exploit scan (if possible)
EXPLOITABLE=0   # Determines whether a scan is possible 


if [[ -r /etc/shadow ]];
    then EXPLOITABLE=1;     # Exploit exists within system
    else EXPLOITABLE=0;     # Exploit does not exist within system
fi

if [[ "$EXPLOIT" = 1 ]] && [[ "$EXPLOITABLE" = 1 ]]; 
    then /bin/bash exploits/readable-shadow-exploit.sh
fi

