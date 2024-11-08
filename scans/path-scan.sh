#! /bin/bash

EXPLOIT=0
EXPLOITABLE=0

curr_dir=$(pwd)

paths=$(echo $PATH | sed 's/:/\n/g')

writable_dirs=''
writable_bins=''

# for every path within PATH, check if it is writable. if it is, save it to a variable.
# if not, check if we own it. if we do and we want to exploit, modify the permisions and save it.
for path in $paths; do
        
	echo Checking ${path}...
        writable=$(check_writable "$path" "$EXPLOIT")
	if [[ "$writable" = true ]]; then
                writable_dirs+=${path}$'\n'
	fi
done

# for every writable directory, check if there are any writable binaries within. if there are any, save them to a vaciable
# if not, check if we own it. if we do and we want to exploit, modify the permisions and save it.
for dir in $writable_dirs; do
	echo ${dir} is writable! Scanning...
	cd "$dir"
        for file in *; do
		if [[ -f "$file" ]]; then
        		writable=$(check_writable "$file" "$EXPLOIT")
			if [[ "$writable" = true ]]; then
				echo ${dir}/${file} is exploitable!
        			writable_bins+=${dir}/${file}':'
				EXPLOITABLE=1
			fi
                fi
        done
done

cd "$curr_dir"

if [[ "$EXPLOITABLE" == 1 ]]; then
	# writes the exploitable files to the correct exploit file
	sed -i "s#exploitable\=.*#exploitable\=${writable_bins}#g" exploits/path-exploit.sh

	if [[ "$EXPLOIT" = 1 ]]; then
		/bin/bash exploits/path-exploit.sh
	fi
fi
