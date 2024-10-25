#! /bin/bash

sudo_ver=$(sudo -V | grep "Sudo ver" | awk '{print $3; exit}' | awk -F '.' '{print $2}') #$ means execute the following 
                                           # () means its a command, dont use with variable
if [[ $sudo_ver -eq 8 ]]; then echo vulnerable; else echo not vulnerable; fi

#research how to downgrade sudo ver in aws
