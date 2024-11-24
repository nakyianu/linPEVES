#! /bin/bash
# Readable shadow scan

EXPLOIT=1       # Determines whether user wants to exploit scan (if possible)
EXPLOITABLE=0   # Determines whether a scan is possible 
VERBOSE=0

# Checks if /etc/shadow is readable by the current user
if [[ -r /etc/shadow ]]; then

    # File is readabable—exploit possible
    EXPLOITABLE=1;

    # File is not readable—exploit NOT possible
    else EXPLOITABLE=0;
fi

# If user wants to exploit AND shadow is readable, perform exploit
if [[ "$EXPLOIT" = 1 ]] && [[ "$EXPLOITABLE" = 1 ]]; then

    # Pass EXPLOITABLE into exploit
    sed -i "s#EXPLOITABLE=.*#EXPLOITABLE=1#g" exploits/readable-shadow-exploit.sh

    # Call exploit file
    /bin/bash exploits/readable-shadow-exploit.sh
fi

