#! /bin/bash

#id port  mdp
#01 22000 r3Y7Ja1r

old="$IFS"
IFS='
'
echo -n "" > passwords
for j in $(ls containers)
do
	for i in $(cat containers/$j)
	do
		IFS=' ' read -ra my_array <<< "$i"
		id="${my_array[0]}"
		name="tp1e4-$id"
		port="${my_array[1]}"
		pass="${my_array[2]}"
		echo "$id:$name root:$pass"
		echo -e "$pass\n$pass" | docker exec -i $name passwd
		echo "$name localhost:$port root:$pass" >> passwords
	done
done
echo -ne "\n"
