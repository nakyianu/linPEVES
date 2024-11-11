#! /bin/bash
EXPLOIT=0
EXPLOITABLE=0

sudo_ver=$(sudo -V | grep "Sudo ver" | awk '{print $3; exit}' | awk -F '.' '{print $2}') # $ means execute the following 
                                           # () means its a command, dont use with variable
if [[ $sudo_ver -eq 8 ]]; 
    then EXPLOITABLE=1; 
    else EXPLOITABLE=0; 
fi

if [[ "$EXPLOIT" = 1 ]] && [[ "$EXPLOITABLE" = 1 ]]; 
    then /bin/bash exploits/sudo-exploit.sh
fi

