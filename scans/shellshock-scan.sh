#! /bin/bash

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

version=$(bash --version | grep 'version' | awk '{print $4}')
version=${version/(*/}

oldIFS=$IFS
IFS='.' read -r -a version_arr <<< "$version"

if [[ "${version_arr[0]}" -le '4' ]] && [[ "${version_arr[1]}" -le '3' ]]; then
	shellshock=$(env X=”() { :;} ; echo Bash is Infected” /bin/sh -c “echo completed)
		
	if [[ "$shellshock" != "not-vulnerable" ]]; then
		echo "Version suscpetible to shellshock exploit"
		EXPLOITABLE=1
	fi
fi

if [ "$EXPLOIT" = 1 ]; then
    if [ "$EXPLOITABLE" = 1 ]; then
		/bin/bash exploits/writable-passwd-exploit.sh
	else
		echo "Not exploitable, skipping exploit."
	fi
fi

IFS=$oldIFS
