find / -perm -4000 2>/dev/null > find_pkexec

result=$(grep "pkexec" find_pkexec)

sudo_access=$(sudo -l -U $(whoami) | grep -o ALL | head -1)

if [ -n "$result" ] && [ -n "$sudo_access" ]; then
	PKEXEC=1
	export PKEXEC
fi


rm find_pkexec
