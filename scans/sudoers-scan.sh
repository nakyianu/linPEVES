#! /bin/bash

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

echo "Checking sudo access"

sudo_access=$(sudo -l -U $(whoami) | grep -o ALL | head -1)
no_passwd=$(sudo -l -U $(whoami) | grep -o NOPASSWD | head -1)

if [[ -w /etc/sudoers ]]; 
then
	echo "/etc/sudoers is writable by user"
	EXPLOITABLE=1
fi

if [[ -n "$sudo_access" ]] && [[ -n "$no_passwd" ]];
then
	echo "USER $(whoami) already has sudo access with NOPASSWD"

else
	if [[ "$EXPLOITABLE" -eq 1 ]]; 
	then
		run_exploit "sudoers"
	else
		test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
		exit 0
	fi
fi
