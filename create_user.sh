#!/bin/bash
read -p "path to file csv: " file
for i in $(cat $file)
do
	email=`echo $i | cut -d "," -f 4`
	password=`echo $i | cut -d "," -f 3`
	frist_name=`echo $i | cut -d "," -f 1`
	last_name=`echo $i | cut -d "," -f 2`
	su - zimbra -c "zmprov createAccount $email $password displayName '$frist_name $last_name' givenName '$frist_name' sn '$last_name'"
	echo "Creating email $email is successfull!!!"
done
