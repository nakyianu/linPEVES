#! /bin/bash

# over one minute keep track of all the processes that run
# get any that are run with /bin/* executables 
script_files=$(for i in $(seq 1 610); do ps -u root --format cmd >> /tmp/procs.tmp; sleep 0.1; done; sort /tmp/procs.tmp | uniq -c | grep -v "\[" | grep -v -E "\s*[6-9][0-9][0-9]|\s*[1-9][0-9][0-9][0-9]" | grep "/bin/" | awk '{print $NF}')

rm /tmp/procs.tmp

echo $script_files

while read line; do
	echo $(stat -c "%a %U %G %n" $line)
	perms=$(stat -c "%a" $line)
	user=$(stat -c "%U" $line)
	group=$(stat -c "%G" $line)

	# if [[ -w $line ]] # if this file is writable by this user

	if [[ $user == $(whoami) ]] && [[ $perms =~ [2637]** ]] then
		# chmod u+rw $line
		echo omg you own this file and you can edit it
	elif [[ $($group | grep -qw $(groups)) ]] && [[ $perms =~ *[2637]* ]]; then
		echo omg you are in a group that can edit this file
	elif [[ $perms =~ **[2637] ]]; then
		echo omg anyone can edit this file
	else
		echo you cannot edit this file
	fi
done <<< "$script_files"
