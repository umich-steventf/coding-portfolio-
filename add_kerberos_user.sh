#!/bin/bash
read -p"uniqname to add: " uniqname
echo "Looking up UID via login.itcs.umich.edu."

uid=$(ldapsearch -x -h ldap.umich.edu -b ou=People,dc=umich,dc=edu -s one -LLL uid=$uniqname uidNumber |tail -n +2 | sed 's/.*://')
name=$(ldapsearch -x -h ldap.umich.edu -b ou=People,dc=umich,dc=edu -s one -LLL uid=$uniqname displayName |tail -n +2 | sed 's/.*://')

if [ "x$uid" == "x" ]; then
	echo "No UID found for $uniqname."
	exit 1
fi

echo "UID: $uid"
echo "Name: $name"
echo "Adding user and updating passwd and home directory with sudo."
sudo /usr/sbin/useradd "$uniqname"
sudo sed -r -i -e "s/$uniqname:x:[0-9]+:([0-9]+):[^:]*/$uniqname:x:$uid:\1:$name/" /etc/passwd
sudo sed -r -i -e "s/$uniqname:[^:]+:/$uniqname:!!:/" /etc/shadow
sudo chown -R "$uniqname:$uniqname" "/home/$uniqname/"
unset uid
unset name
echo "Add user to sudoers? (y/N)"
read answer
if [ "${answer:0:1}" = "y" -o "${answer:0:1}" = "Y" ]; then
	echo "Adding user to sudoers."
	sudo su -s "$(which bash)" -c 'echo "'$uniqname'    ALL=(ALL)       ALL" >> /etc/sudoers'
fi
unset uniqname
