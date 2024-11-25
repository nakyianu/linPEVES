#!/bin/bash
#
# Authors: Aadi Akyianu, Lazuli Kleinhans
# Sources: Example taken from http://argbash.readthedocs.io/en/stable/example.html
#
#
# Created by Argbash
# ARG_OPTIONAL_SINGLE([scan],[s],[list of scans to run])
# ARG_OPTIONAL_SINGLE([exploit],[e],[list of exploits to run])
# ARG_OPTIONAL_BOOLEAN([prompt],[p],[prompt user before exploit])
# ARG_OPTIONAL_BOOLEAN([verbose],[v],[add verbosity to script (false by default)])
# ARG_OPTIONAL_ACTION([--list], [-l], [Lists all scans and their associated numerical indices])
# ARG_VERSION([echo "linPEVES $version"])
# ARG_HELP([The general script's help msg])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.9.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate


version="v1.0"
VERBOSE=0
EXPLOIT=0
PROMPT=0
SCAN=0
ERROR='\033[1;31m'
WARNING='\033[1;33m'
SUCCESS='\033[1;32m'
NC='\033[0m'

exploits=()
exploits_to_run=()
scans=()

ALL_FILES=(
"cron"
"env-var"
"path"
"pkexec"
"readable-passwd"
"readable-shadow"
"shellshock"
"sudo"
"sudoers"
"systemctl-bin"
"writable-passwd"
"writable-shadow"
)

# ALL_SCANS=(
# "cron-scan.sh"
# "path-scan.sh"
# "pkexec-scan.sh"
# "readable-shadow-scan.sh"
# "shellshock-scan.sh"
# "sudo-scan.sh"
# "sudoers-scan.sh"
# "systemctl-bin-scan.sh"
# "writable-passwd-scan.sh"
# "writable-shadow-scan.sh"
# )

# ALL_EXPLOITS=("cron-exploit.sh"
# "path-exploit.sh"
# "pkexec-exploit.sh"
# "readable-shadow-exploit.sh"
# "shellshock-exploit.sh"
# "sudo-exploit.sh"
# "sudoers-exploit.sh"
# "systemctl-bin-exploit.sh"
# "writable-passwd-exploit.sh"
# "writable-shadow-exploit.sh"
# )


# Kills process when called
# Args:
# 	$1: Exit message (print to stderr)
# 	$2: Exit code (default is 1)
# if env var _PRINT_HELP is set to 'yes', the usage is printed to stderr (prior to $1)
die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	echo
	exit "${_ret}"
}


# Function that evaluates whether a value passed to it begins by a character
# that is a short option of an argument the script knows about.
# This is required in order to support getopts-like short options grouping.
begins_with_short_option()
{
	local first_option all_short_options='sevh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# Default Initialization because all arugments are optional
_arg_scan=() 				# default value
_arg_exploit=()				# default value

# not fully supported yet (not for mvp)
_arg_verbose=0   					# default value
_arg_prompt=0    					# default value


# prints usage and info about each argument
print_help()
{
	echo 
	echo "██╗           ██████╗ ███████╗██╗   ██╗███████╗███████╗"
	echo "██║██╗        ██╔══██╗██╔════╝██║   ██║██╔════╝██╔════╝"
	echo "██║╚═╝█████╗  ██████╔╝█████╗  ██║   ██║█████╗  ███████╗"
	echo "██║██╗██╔══██╗██╔═══╝ ██╔══╝  ╚██╗ ██╔╝██╔══╝  ╚════██║"
	echo "██║██║██║  ██║██║     ███████╗ ╚████╔╝ ███████╗███████║"
	echo "╚═╝╚═╝╚═╝  ╚═╝╚═╝     ╚══════╝  ╚═══╝  ╚══════╝╚══════╝"
	echo ""
	echo ""


	printf 'Usage: %s [-s|--scan <args>] || [-e|--exploit <args>] [-p|--prompt] [-v|--verbose] [-V|--version] [-l|--list] [-h|--help]\n' "$0"
	printf '\t%s\n' "-s, --scan: list of scans to run (no default)"
	printf '\t%s\n' "-e, --exploit: list of exploits to run (no default)"
	# not for MVP
	printf '\t%s\n' "-p, --prompt: prompt user before exploit (false by default)"
	printf '\t%s\n' "-v, --verbose: add verbosity to script (false by default)"
	printf '\t%s\n' "-l, --list: Lists all scans and their associated numerical indices"
	printf '\t%s\n' "-V, --version: Prints version"
	printf '\t%s\n\n' "-h, --help: Prints help"
}

# called in --list to help users know which scan is associated with which exploit.
print_scans()
{
	printf '\n%s\n\n' "- [ List of Scans and Exploits ] -" 
	printf '%s\n' "  # |             SCANS             |           EXPLOITS            "
	printf '%s\n' "----+-------------------------------+-------------------------------"
	printf '%s\n' "  0 | cron-scan                     | cron-exploit                  "
	printf '%s\n' "  1 | env-var-scan                  | env-var-exploit               "
	printf '%s\n' "  2 | path-scan                     | path-exploit                  "
	printf '%s\n' "  3 | pkexec-scan                   | pkexec-exploit                "
	printf '%s\n' "  4 | readable-passwd-scan          | readable-passwd-exploit       "
	printf '%s\n' "  5 | readable-shadow-scan          | readable-shadow-exploit       "
	printf '%s\n' "  6 | shellshock-scan               | shellshock-exploit            "
	printf '%s\n' "  7 | sudo-scan                     | sudo-exploit                  "
	printf '%s\n' "  8 | sudoers-scan                  | sudoers-exploit               "
	printf '%s\n' "  9 | systemctl-bin-scan            | systemctl-bin-exploit         "
	printf '%s\n' " 10 | writable-passwd-scan          | writable-passwd-exploit       "
	printf '%s\n\n' " 11 | writable-shadow-scan          | writable-shadow-exploit       "
}

# Parses cli arguments
parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			# Supports whitespace delimitation between argument and value.
			# Expects the --scan or -s value.
			# Reach for the next argument to get the value.
			# Supports bash list expansion and allows for multiple values for the --scan and -s parameters
			-s|--scan)
				# test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				SCAN=1

				# iterates through the arguments and adds then to scan list
				while test $# -gt 0;
				do
					# goes until it no longer encounters a number
					if [[ "$2" =~ [0-9] ]];
					then
						_arg_scan[${#_arg_scan[@]}]+="$2"
						shift
					else 
						break
					fi	
				done
				;;
			
			-e|--exploit)
				# test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				EXPLOIT=1
				# iterates through the arguments and adds then to exploit list
				while test $# -gt 0;
				do
					# goes until it no longer encounters a number
					if [[ "$2" =~ [0-9] ]];
					then
						_arg_exploit[${#_arg_exploit[@]}]+="$2"
						shift
					else 
						break
					fi	
				done
				;;
			
			-p|--prompt)
				_arg_prompt=1
				;;
			# Supports short argument clustering,
			# Since -p doesn't accept value, other short options may be appended to it, so we watch for -p*.
			# After stripping the leading -p from the argument, we have to make sure
			# first character that follows corresponds to a short option.
			-p*)
				_arg_prompt=1
				;;
			
			-v|--verbose)
				_arg_verbose=1
				;;
			# Supports argument clustering, similar concept to -p.
			-v*)
				_arg_verbose=1
				;;
			
			-l|--list)
				print_scans
				exit 0
				;;
			
			-V|--version)
				echo "linPEVES $version"
				exit 0
				;;
			
			# prints help and exits (does not currently support --help [command])
			-h|--help)
				print_help
				exit 0
				;;
			# Supports argument clustering, similar concept to -p and -v.
			-h*)
				print_help
				exit 0
				;;
			
			# anything else
			*)
				echo "$@"
				_PRINT_HELP=yes die "Unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}


# makes sure that the arguments passed in are appropriate
# currently very rudimentary (does not yet catch errors where a number is inputted that doesn't correspond with a scan/exploit.)
validate_arguments() 
{
	VERBOSE=$_arg_verbose
	PROMPT=$_arg_prompt
	
	# check there is at least one scan or exploit to execute
	if [ $EXPLOIT -eq 0 ] && [ $SCAN -eq 0 ]; 
	then
		_PRINT_HELP=yes die "No scans or exploits specified" 1
	fi
	
	if [ "$SCAN" -eq 1 ]; 
	then
		if [ "${#_arg_scan[@]}" -eq 0 ];
		then
			scans=${ALL_FILES[@]}
		else
			for scan_num in ${_arg_scan[@]}; do
				scans[${#scans[@]}]+=${ALL_FILES[$scan_num]}
			done
		fi
	fi

	if [ "$EXPLOIT" -eq 1 ]; 
	then
		if [ "$PROMPT" -eq 1 ]; 
		then
			EXPLOIT=2
		fi
		echo ${#_arg_exploit[@]}
		if [ "${#_arg_exploit[@]}" -eq 0 ];
		then
			exploits=${ALL_FILES[@]}
			for exploit in ${exploits[@]};
			do 
				if [[ ! "${scans[@]}" =~ "$exploit" ]];
				then
					exploits_to_run[${#exploits_to_run[@]}]+=$exploit
				fi
			done
		else
			for exploit_num in ${_arg_exploit[@]}; 
			do
				exploit=${ALL_FILES[$exploit_num]}
				exploits[${#exploits[@]}]+=$exploit

				if [[ ! "${scans[@]}" =~ "$exploit" ]];
				then
					exploits_to_run[${#exploits_to_run[@]}]+=$exploit
				fi
			done
		fi
	fi

}




# reset function used to reset scan files to EXPLOIT=0 and VERBOSE=0
reset_flags()
{
	for scan in ${ALL_SCANS[@]};
	do
		sed -i '' 's/EXPLOIT\=.*/EXPLOIT\=0/' "scans/$scan-scan.sh";
		sed -i '' 's/VERBOSE\=.*/VERBOSE\=0/' "scans/$scan-scan.sh";
		sed -i '' 's/VERBOSE\=.*/VERBOSE\=0/' "exploits/$scan-exploit.sh";
	done
}

# goes through the files that are to be exploited and sets EXPLOIT flag
# sets VERBOSE flag for all files to be executed
set_flags()
{
	for exploit in ${exploits[@]};
	do
		sed -i '' "s/EXPLOIT=.*/EXPLOIT=$EXPLOIT/" "scans/$exploit-scan.sh"
		sed -i '' "s/VERBOSE=.*/VERBOSE=$VERBOSE/" "exploits/$exploit-exploit.sh"
	done

	for scan in ${scans[@]};
	do
		sed -i '' "s/VERBOSE=.*/VERBOSE=$VERBOSE/" "scans/$scan-scan.sh"
	done
}


# global function for scan files to use as it is a common check
check_writable() {
	FILE=$1
	EXPLOIT=$2

	user=$(stat -c "%U" "$FILE" 2>/dev/null)
        writable=false

	# if this file is writable by this user
        if [[ -w "$FILE" ]]; then 
		writable=true
        elif [[ "$EXPLOIT" = 1 ]] && [[ $user == $(whoami) ]]; then
		chmod u+w $FILE
		writable=true
        fi

	echo $writable
}

# global function to print statements when verbosity is enabled
# 0 = Default
# 1 = Success
# 2 = Warning
# 3 = Error
print_verbosity() 
{
	statement=$1
	flag=$2

	if [[ "$VERBOSE" -eq 1 ]];
	then
		if [[ "$flag" = 3 ]];
		then
			echo -e "ERROR: $ERROR ${statement^^} $NC"
		elif [[ "$flag" = 2 ]];
		then
			echo -e "WARNING: $WARNING ${statement^^} $NC"
		elif [[ "$flag" = 1 ]];
		then
			echo -e "SUCCESS: $SUCCESS ${statement^^} $NC"
		elif [[ "$flag" = 0 ]];
		then
			echo "${statement^^}"
		fi
	fi
}

# global function to run exploit files with prompt value
run_exploit()
{
	exploit=$1

	if [[ "$EXPLOIT" -eq 0 ]];
	then
		exit 0

	elif [[ "$EXPLOIT" -eq 1 ]];
	then
		/bin/bash "exploits/$exploit-exploit.sh"
	
	elif [[ "$EXPLOIT" -eq 2 ]];
	then
		read -sp "Proceed with exploit? (Y/n): " response
		echo -e "\n"
		if [[ "$response" == [yY] ]] || [[ "$response" == [yY][eE][sS] ]]; 
		then 
			/bin/bash "exploits/$exploit-exploit.sh"
		else 
			echo "Skipping exploit..."
			exit 0 
		fi
	fi
}

run()
{
	# runs the scans first
	for scan in ${scans[@]}; 
	do
		echo "running $scan-scan"
		/bin/bash "scans/$scan-scan.sh"
		echo "done with $scan-scan"
	done

	# once all scans are done, if there are exploits left over, run those
	for exploit in ${exploits_to_run[@]}; 
	do
		echo "running $exploit-exploit"
		/bin/bash "exploits/$exploit-exploit.sh"
		echo "done with $exploit-exploit"
	done
}

# Now call all the functions defined above that are needed to get the job done
parse_commandline "$@"
reset_flags
validate_arguments
set_flags
run

# exports function for other files to call it
export -f check_writable
export -f print_verbosity
export -f run_exploit


# echo "Value of --scan: ${_arg_scan[@]}"
# echo "Value of --exploit: ${_arg_exploit[@]}"
# echo "Value of --prompt: $_arg_prompt"
# echo "Value of --verbose: $_arg_verbose"
# echo "Value of EXPLOIT: $EXPLOIT"
# echo "Value of VERBOSE: $VERBOSE"
# echo "Value of scans: ${scans[@]}"
# echo "Value of exploits: ${exploits[@]}"
# echo "Value of exploits to run: ${exploits_to_run[@]}"
