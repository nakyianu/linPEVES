#! /bin/bash
EXPLOIT=0
EXPLOITABLE=0

if [[ -w /etc/passwd ]]; then
	echo "/etc/passwd file is writable by user"
	EXPLOITABLE=1
fi

echo $EXPLOITABLE
