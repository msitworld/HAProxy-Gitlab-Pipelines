#!/bin/bash
adddate() { 
    while IFS= read -r line       
    do 
        echo "$(date) $line" 
    done 
} 

for file in $( find /tmp -type f -mtime +0 -name '*.dolphin.temp' ) 
do 
    echo $file ls -la $file | adddate >> /tmp/clean.log 
done

find / -type f -mtime +0 -name '*.dolphin.temp' | xargs echo

exit 0