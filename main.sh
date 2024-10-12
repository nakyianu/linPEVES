#! /bin/bash

scans=$(ls scans)
for scan in $scans; 
do
    echo "running $scan"
    /bin/bash scans/$scan
    echo "done with $scan"
done
