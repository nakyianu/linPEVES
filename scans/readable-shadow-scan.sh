#! /bin/bash
# Readable shadow scan

# Determines whether user wants to exploit scan (if possible)
EXPLOIT=1   
# Determines whether a scan is possible 
EXPLOITABLE=0
VERBOSE=0

# Checks if /etc/shadow is readable by the current user
if [[ -r /etc/shadow ]]; then

    # File is readabable—exploit possible
    EXPLOITABLE=1;

    # File is not readable—exploit NOT possible
    else EXPLOITABLE=0;
fi

# If user wants to exploit AND shadow is readable, perform exploit
if [[ "$EXPLOITABLE" = 1 ]]; then

    # Pass EXPLOITABLE into exploit
    sed -i "s#EXPLOITABLE=.*#EXPLOITABLE=1#g" exploits/readable-shadow-exploit.sh

    # Call exploit file
    run_exploit "readable-shadow"
else
    test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
    exit 0
fi

