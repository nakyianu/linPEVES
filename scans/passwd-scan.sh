#! /bin/bash
EXPLOIT=0
EXPLOITABLE=0

if [[ -w /etc/passwd ]]; then
	echo "/etc/passwd file is writable by user"
	EXPLOITABLE=1
fi

# check to see what hash is used for the password

echo $EXPLOITABLE

if [[ $EXPLOIT = 1 ]]; then

fi


# check to see that shasum is installed.
