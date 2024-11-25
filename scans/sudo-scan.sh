#! /bin/bash
# Sudo version scan

EXPLOIT=1
EXPLOITABLE=0
VERBOSE=0

# Folder for paths you can take to edit sudo
exploitable_paths= ''

# Check version of sudo to see if it has not been updated
sudo_ver=$(sudo -V | grep "Sudo ver" | awk '{print $3; exit}' | awk -F '.' '{print $2}') 

# Scans lines of sudo -l to extract commands where the current user can run as root without a password (paths only)
# Adds those lines of paths to the exploitable_paths file
exploitable_paths=$(sudo -l | grep -E "sudoedit|sudo -e" | grep -E '\(root\)' | cut -d ')' -f 2-)

# Indicate it is exploitable if the version is old enough and can edit sudo                                
if [[ $sudo_ver -eq 8 ]] && [[ -z $"exploitable_paths"]]; then
    EXPLOITABLE=1; 
    else EXPLOITABLE=0; 
fi

# Makes exploitable_paths accessible to exploit
if [[ "$EXPLOITABLE" == 1 ]]; then
    sed -i "s#exploitable\=.*#exploitable\=${exploitable_paths}#g" exploits/sudo-exploit.sh
    run_exploit "sudo"
else
    test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
    exit 0
fi
