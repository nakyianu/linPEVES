#! /bin/sh

EXPLOIT=0
EXPLOITABLE=0

if [ -w /etc/sudoers ]; then
	EXPLOITABLE=1
fi

if [ "$EXPLOIT" = 1 ]; then
       if [ "$EXPLOITABLE=1" ]; then
# run the exploit file
	else
		echo "Not exploitable, skipping exploit."

else 
	exit
fi
