paths=$(echo $PATH | sed 's/:/\n/g')
outfile=./writable_dirs

for path in $paths;
do
	if [ -w $path ]; then
		echo $path >> $outfile
	fi
done
