#! /bin/bash

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0


print_verbosity "Checking writability of /etc/sudoers" 0

file=$(ls /etc/sudoers | grep -v README)

if [[ -w /etc/sudoers ]]; 
then
	print_verbosity "/etc/sudoers is writable by user" 1
	EXPLOITABLE=1
fi

if [[ "$EXPLOITABLE" -eq 1 ]]; 
then
	run_exploit "sudoers"
else
	test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
	exit 0
fi

