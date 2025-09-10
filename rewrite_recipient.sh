#! /usr/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0  Mail_Id"
    echo
    mailq
    exit 1
fi

adr_from=$(postqueue -p | grep $1 | awk '{print $7}')

if [ ${#adr_from} -eq 0 ]; then
    echo "Error: No such message $1"
    exit 1
fi

adr_to=$(postqueue -p | grep $1 -A 3| awk 'NR==3 {print $1}' | sed 's/@xxxx.com.ua/@xxxx.ua/')

echo "ReSend $1 From $adr_from To $adr_to"

#postqueue -p | grep '$1' -B 2
postsuper -h $1
postcat -qbh $1 > /tmp/m.eml
sendmail -f $adr_from $adr_to < /tmp/m.eml
postsuper -d $1
rm -f /tmp/m.eml
