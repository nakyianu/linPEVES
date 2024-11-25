#!/bin/bash

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

print_verbosity "Looking for pkexec on system" 0

result=$(find / -perm -4000 2>/dev/null | grep "pkexec")

print_verbosity "Checking for sudo access" 0
sudo_access=$(sudo -l -U $(whoami) | grep -o ALL | head -1)

if [ -n "$result" ] && [ -n "$sudo_access" ]; then
	print_verbosity "pkexec is avialable and $whoami has sudo access" 1
	EXPLOITABLE=1
fi


if [ "$EXPLOITABLE" -eq 1 ]; then
	run_exploit "pkexec"
else
	test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
	exit 0
fi
