#!/bin/bash

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

print_verbosity "Looking for pkexec on system" 0

result=$(find / -perm -4000 2>/dev/null | grep "pkexec")

if [[ -n $result ]]; then
	print_verbosity "Found pkexec!" 1
else 
	print_verbosity "pkexec not on system" 3
	test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
	exit 0
fi

print_verbosity "Checking writablity of /etc/polkit-1/localauthority.conf.d/" 0

# file=$(ls /etc/polkit-1/localauthority.conf.d* | grep 50)



if [[ -w /etc/polkit-1/localauthority.conf.d ]] && [[ -n "$result" ]]; then
	print_verbosity "pkexec is available and /etc/polkit-1/localauthority.conf.d/ is writable" 1
	EXPLOITABLE=1
fi


if [ "$EXPLOITABLE" -eq 1 ]; then
	run_exploit "pkexec"
else
	test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
	exit 0
fi
