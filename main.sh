#! /bin/bash

check_writable() {
	FILE=$1
	EXPLOIT=$2

	user=$(stat -c "%U" "$FILE" 2>/dev/null)
        writable=false

        if [[ -w "$FILE" ]] then # if this file is writable by this user
		writable=true
        elif [[ "$EXPLOIT" = 1 ]] && [[ $user == $(whoami) ]] then
		chmod u+w $FILE
		writable=true
        fi

	echo $writable
}

export -f check_writable

#scans=$(ls scans)
scans="path-scan.sh"
for scan in $scans; 
do
    echo "running $scan"
    /bin/bash scans/$scan
    echo "done with $scan"
done
