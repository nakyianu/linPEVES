#! /bin/bash

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

curr_dir=$(pwd)

# get locations of the .service files
dirs=$(systemctl show | grep UnitPath | sed 's/.*=//g')

services=''
execs=''

for dir in $dirs; do
	# if it is a directory and not a file, cd into it and find all .service files within
	if [[ -d "$dir" ]]; then
		print_verbosity "Looking in $dir for .service files..." 0
		cd "$dir"
		for file in *; do
			# if the file's extension is '.service', then add it to the list
                        if [[ "${file: -8}" == ".service" ]]; then
                                print_verbosity "Found ${dir}/${file}" 0
                                services+=${dir}/${file}$'\n'
				execs+=$(cat ${file} 2>/dev/null | grep -oP "^Exec(?:Start|Stop)=[-+@!\s]*\K/(.*)$")$'\n' 
                        fi
                done
	fi
done

print_verbosity "Checking for exploitable binaries within .service files..." 0

# remove blank lines
execs=$(echo "${execs}" | sed '/^\s*$/d' | awk '{ print $1 }' | sort | uniq)

writable_bins=''

for bin in ${execs}; do
	writable=$(check_writable "$bin" "$EXPLOIT")
	if [[ "$writable" = true ]]; then
		print_verbosity "${bin} is exploitable!" 1
		writable_bins+=${bin}':'
		EXPLOITABLE=1
	fi
done

print_verbosity "Checking systemctl PATH for writable directories..." 0

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
		print_verbosity "${dir} is writable!" 1
		writable_dirs+=$dir$'\n'
	fi
done

for dir in $writable_dirs; do
	print_verbosity "Checking ${dir} for exploitable binaries..." 0
	cd "$dir"
	for file in *; do
		if [[ -f "$file" ]]; then
			writable=$(check_writable "$file" "$EXPLOIT")
			if [[ "$writable" = true ]]; then
				print_verbosity "${dir}/${file} is exploitable!" 1
				writable_bins+=${dir}/${file}':'
				EXPLOITABLE=1
			fi
		fi
	done
done

cd "$curr_dir"

if [[ "$EXPLOITABLE" = 1 ]]; then
	# writes the exploitable files to the correct exploit file
	sed -i "s#exploitable\=.*#exploitable\=${writable_bins}#g" exploits/systemctl-bin-exploit.sh
        run_exploit "systemctl-bin"
else
        test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
        exit 0
fi
