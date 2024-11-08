#! /bin/bash

EXPLOIT=0
EXPLOITABLE=0

echo Monitoring processes that run over the next minute...

# over one minute keep track of all the processes that run
# get any that are run with /bin/* executables 
script_files=$(for i in $(seq 1 610); do ps -u root --format cmd >> /tmp/procs.tmp; sleep 0.1; done; sort /tmp/procs.tmp | uniq -c | grep -v "\[" | grep -v -E "\s*[6-9][0-9][0-9]|\s*[1-9][0-9][0-9][0-9]" | grep "/bin/" | awk '{print $NF}')

echo Monitoring complete!

rm /tmp/procs.tmp

writable_files=''

while read file; do
	writable=$(check_writable "$file" "$EXPLOIT")

	if [[ "$writable" = true ]]; then
		echo ${file} is exploitable!
		writable_files+=${file}':'
		EXPLOITABLE=1
	fi

done <<< "$script_files"

if [[ "$EXPLOITABLE" == 1 ]]; then
	# writes the exploitable files to the correct exploit file
	sed -i "s#exploitable\=.*#exploitable\=${writable_files}#g" exploits/cron-exploit.sh

	if [[ "$EXPLOIT" = 1 ]]; then
		/bin/bash exploits/cron-exploit.sh
	fi
fi
