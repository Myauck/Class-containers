#! /bin/bash

#id port  mdp
old="$IFS"
IFS='
'
for i in $(<data)
do
	IFS=' ' read -ra my_array <<< "$i"
	id="${my_array[0]}"
	port="${my_array[1]}"
    pass=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-12})
	echo "name:tp1e4-$id port:$port password:$pass"
	docker run -d -p $port:22 --name tp1e4-$id linuxtp /usr/sbin/sshd -D
	echo "$id $port $pass" > containers/tp1e4-$id
done
exec ./apply-passwords.sh
