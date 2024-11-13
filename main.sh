#!/bin/bash
#
# This is a rather minimal example Argbash potential
# Example taken from http://argbash.readthedocs.io/en/stable/example.html
#
version="v1.0"
VERBOSE=false
EXPLOIT=0
ALL_SCANS=("cron-scan.sh" "path-scan.sh" "pkexec-scan.sh" "readable-shadow-scan.sh" "shellshock-scan.sh" "sudo-scan.sh" "sudoers-scan.sh" "systemctl-bin-scan.sh" "writable-passwd-scan.sh" "writable-shadow-scan.sh")
ALL_EXPLOITS=("cron-exploit.sh" "path-exploit.sh" "pkexec-exploit.sh" "readable-shadow-exploit.sh" "shellshock-exploit.sh" "sudo-exploit.sh" "sudoers-exploit.sh" "systemctl-bin-exploit.sh" "writable-passwd-exploit.sh" "writable-shadow-exploit.sh")
exploits=()
scans=()
#
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


# # When called, the process ends.
# Args:
# 	$1: The exit message (print to stderr)
# 	$2: The exit code (default is 1)
# if env var _PRINT_HELP is set to 'yes', the usage is print to stderr (prior to $1)
# Example:
# 	test -f "$_arg_infile" || _PRINT_HELP=yes die "Can't continue, have to supply file as an argument, got '$_arg_infile'" 4
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

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_scan=()
_arg_exploit=()

# not for mvp
# _arg_prompt=false
# _arg_verbose=false


# Function that prints general usage of the script.
# This is useful if users asks for it, or if there is an argument parsing error (unexpected / spurious arguments)
# and it makes sense to remind the user how the script is supposed to be called.
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


	printf '%s\n' "The general script's help msg"
	printf 'Usage: %s [-s|--scan <args>] || [-e|--exploit <args>] [-p|--prompt] [-v|--verbose] [-V|--version] [-l|--list] [-h|--help]\n' "$0"
	printf '\t%s\n' "-s, --scan: list of scans to run (no default)"
	printf '\t%s\n' "-e, --exploit: list of exploits to run (no default)"
	# not for MVP
	# printf '\t%s\n' "-p, --prompt: prompt user before exploit (false by default)"
	# printf '\t%s\n' "-v, --verbose: add verbosity to script (false by default)"
	printf '\t%s\n' "--list: Lists all scans and their associated numerical indices"
	printf '\t%s\n' "--version: Prints version"
	printf '\t%s\n\n' "-h, --help: Prints help"
}

print_scans()
{
	printf '\n%s\n\n' "- [ List of Scans and Exploits ] -" 
	printf '%s\n' "  # |             SCANS             |           EXPLOITS            "
	printf '%s\n' "----+-------------------------------+-------------------------------"
	printf '%s\n' "  0 | cron-scan                     | cron-exploit                  "
	printf '%s\n' "  1 | path-scan                     | path-exploit                  "
	printf '%s\n' "  2 | pkexec-scan                   | pkexec-exploit                "
	printf '%s\n' "  3 | readable-shadow-scan          | readable-shadow-exploit       "
	printf '%s\n' "  4 | shellshock-scan               | shellshock-exploit            "
	printf '%s\n' "  5 | sudo-scan                     | sudo-exploit                  "
	printf '%s\n' "  6 | sudoers-scan                  | sudoers-exploit               "
	printf '%s\n' "  7 | systemctl-bin-scan            | systemctl-bin-exploit         "
	printf '%s\n' "  8 | writable-passwd-scan          | writable-passwd-exploit       "
	printf '%s\n' "  9 | writable-shadow-scan          | writable-shadow-exploit       "
	printf '%s\n' " 10 |                               |                               "
	printf '%s\n' " 11 |                               |                               "
	printf '%s\n\n' " 12 |                               |                               "
}

# The parsing of the command-line
parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			# We support whitespace as a delimiter between option argument and its value.
			# Therefore, we expect the --scan or -s value.
			# so we watch for --scan and -s.
			# Since we know that we got the long or short option,
			# we just reach out for the next argument to get the value.
			-s|--scan)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
		
				while test $# -gt 0;
				do
					if [[ "$2" =~ [0-9] ]];
					then
						_arg_scan[${#_arg_scan[@]}]+="$2"
						shift
					else 
						break
					fi	
				done
				;;
			# We support the = as a delimiter between option argument and its value.
			# Therefore, we expect --scan=value, so we watch for --scan=*
			# For whatever we get, we strip '--scan=' using the ${var##--scan=} notation
			# to get the argument value
			# --scan=*)
			# 	_arg_scan+="${_key##--scan=}"
			# 	;;
			# # We support getopts-style short arguments grouping,
			# # so as -s accepts value, we allow it to be appended to it, so we watch for -s*
			# # and we strip the leading -s from the argument string using the ${var##-s} notation.
			# -s*)
			# 	_arg_scan+="${_key##-s}"
			# 	;;
			# See the comment of option '--scan' to see what's going on here - principle is the same.
			-e|--exploit)
				# test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				EXPLOIT=1
				while test $# -gt 0;
				do
					if [[ "$2" =~ [0-9] ]];
					then
						_arg_exploit[${#_arg_exploit[@]}]+="$2"
						shift
					else 
						break
					fi	
				done
				;;
			# # See the comment of option '--scan=' to see what's going on here - principle is the same.
			# --exploit=*)
			# 	_arg_exploit="${_key##--exploit=}"
			# 	;;
			# # See the comment of option '-s' to see what's going on here - principle is the same.
			# -e*)
			# 	_arg_exploit="${_key##-e}"
			# 	;;
			# The prompt argurment doesn't accept a value,
			# we expect the --prompt, so we watch for it.
			-p|--prompt)
				_arg_prompt=true
				;;
			# See the comment of option '--verbose' to see what's going on here - principle is the same.
			# See the comment of option '-s' to see what's going on here - principle is the same.
			# We support getopts-style short arguments clustering,
			# so as -v doesn't accept value, other short options may be appended to it, so we watch for -v*.
			# After stripping the leading -v from the argument, we have to make sure
			# that the first character that follows coresponds to a short option.
			-p*)
				_arg_prompt=true
				;;
			-v|--verbose)
				_arg_verbose=true
				;;
			# See the comment of option '--verbose' to see what's going on here - principle is the same.
			# See the comment of option '-s' to see what's going on here - principle is the same.
			# We support getopts-style short arguments clustering,
			# so as -v doesn't accept value, other short options may be appended to it, so we watch for -v*.
			# After stripping the leading -v from the argument, we have to make sure
			# that the first character that follows coresponds to a short option.
			-v*)
				_arg_verbose=true
				;;
			-l|--list)
				print_scans
				exit 0
				;;
			-V|--version)
				echo "linPEVES $version"
				exit 0
				;;
			-h|--help)
				print_help
				exit 0
				;;
			# See the comment of option '-v' to see what's going on here - principle is the same.
			-h*)
				print_help
				exit 0
				;;
			*)
				echo "$@"
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

validate_arguments() 
{
	VERBOSE=$_arg_verbose

	if [ "${#_arg_scan[@]}" -eq 0 ] && [ "${#_arg_exploit[@]}" -eq 0 ]; then
		_PRINT_HELP=yes die "No scans or exploits specified" 1
	fi
	if [ "${#_arg_scan[@]}" -gt 0 ]; then
		for scan in ${_arg_scan[@]}; do
			scans[${#scans[@]}]+=$scan
		done
	fi

	if [ "${#_arg_exploit[@]}" -gt 0 ]; then
		if [ "$_arg_prompt" = true ]; then
			EXPLOIT=2
		fi
		for exploit in ${_arg_exploit[@]}; do
			exploits[${#exploits[@]}]+=$exploit
		done
	elif [ "${#_arg_exploit[@]}" -eq 0 ] && [ $EXPLOIT -eq 1 ]; then
		exploits+=("all")
	fi

}

check_writable() {
	FILE=$1
	EXPLOIT=$2

	user=$(stat -c "%U" "$FILE" 2>/dev/null)
        writable=false

		# if this file is writable by this user
        if [[ -w "$FILE" ]]; 
		then 
			writable=true
        elif [[ "$EXPLOIT" = 1 ]] && [[ $user == $(whoami) ]]; then
			chmod u+w $FILE
			writable=true
        fi

	echo $writable
}

export -f check_writable

reset_exploit_flag()
{
for scan in ${ALL_SCANS[@]};
do
	sed -i 's/EXPLOIT\=.*/EXPLOIT\=0/' "scans/$scan";
done
}

# Now call all the functions defined above that are needed to get the job done
parse_commandline "$@"
validate_arguments
reset_exploit_flag

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


# echo "Value of --scan: ${_arg_scan[@]}"
# echo "Value of --exploit: ${_arg_exploit[@]}"
# echo "Value of --prompt: $_arg_prompt"
# echo "Value of --verbose: $_arg_verbose"
# echo "Value of EXPLOIT: $EXPLOIT"
# echo "Value of VERBOSE: $VERBOSE"
# echo "Value of scans: ${scans[@]}"
# echo "Value of exploits: ${exploits[@]}"


for exploit in ${exploits[@]};
do
	sed -i 's/EXPLOIT=.*/EXPLOIT=1/' "scans/${ALL_SCANS[$exploit]}"
done


for scan in ${scans[@]}; 
do
    echo "running ${ALL_SCANS[$scan]}"
    /bin/bash scans/${ALL_SCANS[$scan]}
    echo "done with ${ALL_SCANS[$scan]}"
done

# ] <-- needed because of Argbash
