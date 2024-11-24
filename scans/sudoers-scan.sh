#! /bin/bash

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

print_verbosity "Checking sudo access" 0


print_verbosity "Checking writability of /etc/sudoers" 0

if [[ -w /etc/sudoers ]]; 
then
	print_verbosity "/etc/sudoers is writable by user" 1
	EXPLOITABLE=1
fi

print_verbosity "Checking whether user has sudo access with NOPASSWD" 0 

sudo_access=$(sudo -l -U $(whoami) | grep -o ALL | head -1)
no_passwd=$(sudo -l -U $(whoami) | grep -o NOPASSWD | head -1)

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
