#! /bin/bash

exploit=true


# get locations of the .service files
dirs=$(systemctl show | grep UnitPath | sed 's/.*=//g')

services=''
execs=''

for dir in $dirs; do
	# if it is a directory and not a file, cd into it and find all .service files within
	#echo $dir
	if [[ -d "$dir" ]]; then
		cd "$dir"
		for file in *; do
			# echo $file
			# if the file's extension is '.service', then add it to the list
                        if [[ "${file: -8}" == ".service" ]]; then
                                services+=${dir}/${file}$'\n'
				execs+=$(cat ${file} 2>/dev/null | grep -oP "^Exec(?:Start|Stop)=[-+@!\s]*\K/(.*)$")$'\n' 
                        fi
                done
	fi
done 

# remove blank lines
execs=$(echo "${execs}" | sed '/^\s*$/d' | awk '{ print $1 }' | sort | uniq)

# echo "${execs}"

writable=''

for bin in ${execs}; do
	user=$(stat -c "%U" $bin)
	if [[ -w ${bin} ]]; then
		writable+=$bin$'\n'
	elif [[ $user = $(whoami) ]] && [[ "$exploit" = true ]]; then
		chmod u+rw ${bin}
		writable+=$bin$'\n'
	fi
done


# running this command will define a PATH variable
# containing directories where systemctl binaries are stored,
# separated by colons
eval $(systemctl show-environment) 

writable_dirs=''

# loop through each directory in the PATH variable
for dir in ${PATH//:/ }; do
	# if we have write access to the directory,
	# loop through each file within the directory
	# keeping track of writable files

	user=$(stat -c "%U" ${dir})
	if [[ -w "$dir" ]]; then
                writable_dirs+=$dir$'\n'
	elif [[ $user = $(whoami) ]] && [[ "$exploit" = true ]]; then
                chmod u+rw ${dir}
                writable_dirs+=$dir$'\n'
        fi
done

for dir in $writable_dirs; do
	cd "$dir"
	for file in *; do
		user=$(stat -c "%U" ${file} 2>/dev/null)
		if [[ -f "$file" ]]; then
			if [[ -w "$file" ]]; then
				writable+=${dir}/${file}$'\n'
			elif [[ $user = $(whoami) ]] && [[ "$exploit" = true ]]; then
                		chmod u+rw ${file}
                		writable+=${dir}/${file}$'\n'
			fi
		fi
	done
done

echo Writable: $writable
