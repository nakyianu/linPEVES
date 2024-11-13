#! /bin/sh

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

if [ -w /etc/shadow ]; then
	echo "/etc/shadow file is writable by user"
	EXPLOITABLE=1
fi

if [ "$EXPLOIT" = 1 ]; then
    if [ "$EXPLOITABLE" = 1 ]; then
		/bin/bash exploits/writable-shadow-exploit.sh
	else
		echo "Not exploitable, skipping exploit."

else 
	exit
fi
