#! /bin/bash

check_writable() {
	file=$1
	exploit=$2

	user=$(stat -c "%U" $file)
        writable=false

        if [[ -w $file ]] then # if this file is writable by this user
		writable=true
        elif [[ "$exploit" = true ]] && [[ $user == $(whoami) ]] then
		chmod u+w $file
		writable=true
        fi
}

scans=$(ls scans)
for scan in $scans; 
do
    echo "running $scan"
    /bin/bash scans/$scan
    echo "done with $scan"
done
