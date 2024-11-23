#! /bin/bash

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

version=$(bash --version | grep 'version' | awk '{print $4}')
version=${version/(*/}

oldIFS=$IFS
IFS='.' read -r -a version_arr <<< "$version"

if [[ "${version_arr[0]}" -le '4' ]] && [[ "${version_arr[1]}" -le '3' ]]; then
	shellshock=$(env X="() { :;} ; echo vulnerable" /bin/bash -c echo not-vulnerable)
		
	if [[ "$shellshock" != "not-vulnerable" ]]; then
		echo "Version suscpetible to shellshock exploit"
		EXPLOITABLE=1
	fi
fi

if [ "$EXPLOITABLE" -eq 1 ]; 
then
	run_exploit "shellshock"
else
	test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
	exit 
fi

IFS=$oldIFS
