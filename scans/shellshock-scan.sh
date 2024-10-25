version=$(bash --version | grep 'version' | awk '{print $4}')
version=${version/(*/}

oldIFS=$IFS
IFS='.' read -r -a version_arr <<< "$version"

if [[ "${version_arr[0]}" -le '4' ]];
then
	if [[ "${version_arr[1]}" -le '3' ]];
	then
		SHELLSHOCK=1
		export SHELLSHOCK
	fi
fi

IFS=$oldIFS
