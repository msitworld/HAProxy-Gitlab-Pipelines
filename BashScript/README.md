# Schedualing the script to run on boot

In Linux, we can schedule a bash script in several ways. Before this, we must ensure that the script file is executable by checking its attribute. Otherwise, we could make it executable by `chmod +x test_script.sh`.

## - systemd

The recommended way is using systemd. In this case, we create a service file in `/etc/systemd/system`. For instance, `test_script.service` with below content:

```
[Unit]
Description=Run test script on system startup

[Service]
Type=simple
ExecStart=/bin/bash /home/snapp/test_script.sh

[Install]
WantedBy=multi-user.target
```

Then by executing this command `systemctl enable test_script.service` it will run on startup.

## - cron
Another method to schedule a script to run on startup is the cron job. To do this we must go to corntab editor by executing `crontab -e` and then add this line to the file:

`@reboot /home/snapp/test_script.sh`

## - Other ways

There are other ways such as `init.d` or `rc.local` that would be used as fallbacks. Even so, I prefer `systemd` and `cron`.


# Script description

```
1. #!/bin/bash
2. adddate() { 
3.     while IFS= read -r line       
4.     do 
5.         echo "$(date) $line" 
6.     done 
7. } 
8.
9. for file in $( find /tmp -type f -mtime +0 -name '*.dolphin.temp' ) 
10. do 
11.     echo $file ls -la $file | adddate >> /tmp/clean.log 
12. done
13.
14. find / -type f -mtime +0 -name '*.dolphin.temp' | xargs echo
15.
16. exit 0
```

In line 9, the command `find /tmp -type f -mtime +0 -name '*.dolphin.temp'` returns a list of files that are located in `/tmp` and modified in the last one day or more and their names end with `dolphin.temp`. Then using a loop `for`, adds a line to file `/tmp/clean.log`. The result would be like this:

```
Fri Apr  7 18:39:42 +0430 2022 /tmp/x1.dolphin.temp ls -la /tmp/x1.dolphin.temp
Fri Apr  7 18:39:42 +0430 2022 /tmp/x2.dolphin.temp ls -la /tmp/x2.dolphin.temp
```

As could be seen using `ls -la $file` at line 11 is not correct because it is not executed after `echo`. However, the result of `echo $file ls -la $file` is printed but by using `|` we pass the result to the function `adddate`. The `adddate` read all lines of the files list in turns and prints the current date-time plus path of the file ie. `Fri Apr  7 18:39:42 +0430 2022 /tmp/x1.dolphin.temp`


In line 14, the command `find / -type f -mtime +0 -name '*.dolphin.temp'` again returns a list of files that are located in `/` and modified in the last one day or more and their names end with `dolphin.temp` then per each item executes `echo` using `xargs`. If it could find any file the result would be like this:

`/x1.dolphin.temp /x2.dolphin.temp`


Finally, line 16 tells that everything is done successfully without any error. However, it's not obligatory. In Linux, every command that is successfully executed returns a zero exit code but in other cases, it would be 1, 2, or another code based on the command execution status. We can use `echo $?` to show the last command status. 


# Script problems and security issues

- As it was mentioned, in line 11, `ls -la $file` is redundant and doesn't work correctly.

- The loop `for` doesn't do anything. What action does log it? Delete the old files `*.dolphin.temp`?!

- The `find` command in line 14 has some security issues because it is finding path `/` that contains all essential and systematic directories of Linux. It also do the `find /tmp -type f -mtime +0 -name '*.dolphin.temp'` that is repetitive.

- It's not a problem but `exit 0` could be neglected.


# Suggestions

- It would be better to use `-daystart` in conjunction with `find / -type f -mtime` because it could be more clear. For example, in line 9, we could rewrite the command `find` as `find /tmp -type f -mtime 1 -daystart -name '*.dolphin.temp'`.

- As mentioned before, `exit 0` could be ignored.

- We could substitute lines 2 to 12 of this script for just one line and get the same result which means we could replace these lines:


```
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
```
by this line:

`find /tmp -type f -mtime +0 -name '*.dolphin.temp' | while read file; do echo $(date) "$file"; done >> /tmp/clean.log`
