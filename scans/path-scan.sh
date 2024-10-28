#! /bin/bash

exploit=true

paths=$(echo $PATH | sed 's/:/\n/g')

writable_dirs=''
writable_bins=''

# for every path within PATH, check if it is writable. if it is, save it to a variable.
# if not, check if we own it. if we do and we want to exploit, modify the permisions and save it.
for path in $paths; do
        
	echo Checking ${path}...
        writable=$(check_writable $path $exploit)
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
        		writable=$(check_writable $file $exploit)
			if [[ "$writable" = true ]]; then
        			writable_bins+=${dir}/${file}$'\n'
			fi
                fi
        done
done

# if we want to exploit, inject the exploit into the writable binaries
if [[ "$exploit" = true ]] then
	for bin in $writable_bins; do
		echo Modifying ${bin}...
	done
fi
