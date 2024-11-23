#! /bin/sh

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

echo "Checking sudo access"

sudo_access=$(sudo -l -U $(whoami) | grep -o ALL | head -1)

if [[ -n "$sudo_access" ]];
then
	



if [ -w /etc/sudoers ]; 
then
	echo "/etc/sudoers is writable by user"
	EXPLOITABLE=1
fi


if [ "$EXPLOITABLE" -eq 1 ]; 
then
	run_exploit "sudoers"
else
	test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
	exit 
fi
