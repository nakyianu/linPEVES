#! /bin/bash

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

if [ -w /etc/passwd ]; then
	echo "/etc/passwd file is writable by user"
	EXPLOITABLE=1
fi

# check to see what hash is used for the password


if [ "$EXPLOITABLE" -eq 1 ]; then
	run_exploit "writable-passwd"
else
	test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
	exit 
fi
