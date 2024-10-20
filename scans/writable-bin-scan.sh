#! /bin/bash

exploit=true

writable=''

# running this command will define a PATH variable
# containing directories where systemctl binaries are stored,
# separated by colons
eval $(systemctl show-environment) 

# loop through each directory in the PATH variable
for dir in ${PATH//:/ }; do
	# if we have write access to the directory,
	# loop through each file within the directory
	# keeping track of writable files
	# TODO: check if this user owns anything, if so give write perms
	user=$(stat -c "%U" $dir)

	if [[ -w "$dir" ]]; then
		cd "$dir"
		for file in *; do
			if [[ -f "$file" ]] && [[ -w "$file" ]]; then
				writable+=${dir}/${file}$'\n'
			fi
		done
	fi
done

echo Writable: $writable

# get locations of the .service files
dirs=$(systemctl show | grep UnitPath)
dirs=${dirs#*=}

services=''
execs=''

for dir in $dirs; do
	# TODO: if it is a dir and not a file, cd into it and find all .service files within
	#echo $dir
	if [[ -d "$dir" ]]; then
		cd "$dir"
		for file in *; do
			# echo $file
			# if the file's extension is '.service', then add it to the list
                        if [[ "${file: -8}" == ".service" ]]; then
                                services+=${dir}/${file}$'\n'
				execs+=$(cat ${file} | grep ExecStart=)$'\n'
                        fi
                done
	fi
done 

# echo "${services}"
while read service; do
	echo $service
done <<< "$execs"

#for service in ${execs}; do
#	echo $service
#done
#if [[ "$exploit" = true ]] then
	# echo "modifying ${writable}"
	# TODO: get username to give user sudo perms
	# echo usermod -aG sudo $user > $writable
#fi
