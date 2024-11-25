#! /bin/bash
# Readable passwd scan
#
#   While this scan does check to see if the /etc/passwd file 
# is readable to a user, this does not necessarily pose a danger 
# to the system. Typically, this file IS readable to many unprivileged users.
#
#   In this case, a vulnerability is found when a user's password
# is not hidden from view in /etc/passwd. In other words, a user's 
# password might be on display in this readable file.

exploitable_user=''
EXPLOIT=0
VERBOSE=0

# Checks if /etc/passwd is readable by the current user
if [[ -r /etc/passwd ]]; then

    # Check if a password exists in the /etc/passwd file by looping through every line
    while IFS=: read -r username password rest; do

        # Check if the password field is not "x"
        if [[ "$password" != "x" ]]; then
            print_verbosity "A password was found." 1

            # Storing password, corresponding username, and other elements from that line
            exploitable_user="${username}:${password}:${rest}"
        fi
    done < /etc/passwd

    # File is not readable—exploit NOT possible
    else EXPLOITABLE=0;
fi


# If user wants to exploit AND shadow is readable, perform exploit
if [[ "$EXPLOITABLE" = 1 ]]; then

    # Passing EXPLOITABLE into exploit file
    sed -i "s#exploitable\=.*#exploitable\=${exploitable_user}#g" exploits/readable-passwd-exploit.sh
   
    # Open exploit file
    run_exploit "readable-passwd"
else
    test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
    exit 0
fi
