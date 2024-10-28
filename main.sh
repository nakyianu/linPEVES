#! /bin/bash

check_writable() {
	file=$1
	exploit=$2

	user=$(stat -c "%U" $file 2>/dev/null)
        writable=false

        if [[ -w $file ]] then # if this file is writable by this user
		writable=true
        elif [[ "$exploit" = true ]] && [[ $user == $(whoami) ]] then
		chmod u+w $file
		writable=true
        fi

	echo $writable
}

export -f check_writable

scans=$(ls scans)
for scan in $scans; 
do
    echo "running $scan"
    /bin/bash scans/$scan
    echo "done with $scan"
done
