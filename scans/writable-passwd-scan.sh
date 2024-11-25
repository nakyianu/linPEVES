#! /bin/bash

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

print_verbosity "Checking writability of /etc/passwd" 0

if [[ -w /etc/passwd ]]; then
	print_verbosity "/etc/passwd file is writable by user" 1
	EXPLOITABLE=1
fi


if [[ "$EXPLOITABLE" -eq 1 ]]; then
	run_exploit "writable-passwd"
else
	test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
	exit 0
fi
