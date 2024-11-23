#! /bin/sh

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

if [ -w /etc/shadow ]; then
	echo "/etc/shadow file is writable by user"
	EXPLOITABLE=1
fi

if [ "$EXPLOITABLE" -eq 1 ]; then
	run_exploit "writable-shadow"
else
	test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
	exit 
fi