#! bin bash

if [[ -r /etc/shadow ]];
    then echo you can read the shadow file!!;
    else echo shadow inaccessible;
fi