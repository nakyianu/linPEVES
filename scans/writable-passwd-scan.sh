#! /bin/bash

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

if [ -w /etc/passwd ]; then
	echo "/etc/passwd file is writable by user"
	EXPLOITABLE=1
fi

# check to see what hash is used for the password


if [ "$EXPLOIT" = 1 ]; then
    if [ "$EXPLOITABLE" = 1 ]; then
		/bin/bash exploits/writable-passwd-exploit.sh
	else
		echo "Not exploitable, skipping exploit."
else 
	exit
fi
