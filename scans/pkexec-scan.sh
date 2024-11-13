#!/bin/bash

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

result=$(find / -perm -4000 2>/dev/null | grep "pkexec")

sudo_access=$(sudo -l -U $(whoami) | grep -o ALL | head -1)

if [ -n "$result" ] && [ -n "$sudo_access" ]; then
	EXPLOITABLE=1
fi


if [ "$EXPLOIT" = 1 ]; then
    if [ "$EXPLOITABLE=1" ]; then
		/bin/bash exploits/pkexec-exploit.sh
	else
		echo "Not exploitable, skipping exploit."
else 
	exit
fi
