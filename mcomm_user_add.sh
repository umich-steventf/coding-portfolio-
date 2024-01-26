#!/bin/bash

## to make a ctontab job, save a simple script with the following and point the crontab at that script:
## #!/bin/bash
## /path/to/mcomm_user_add.sh >/dev/null 2>/dev/null

#############################################################################################################
######### edit these variables per group ####################################################################

lab_mcom="BioNMRCore 800 MHz"
it_mcom="LSA IT Research Support North"
local_group="BioNMRCore 800 MHz"
local_it="it-admins"
#############################################################################################################
######### gets gid oc lab_mcom and makes a local group with that gid and the name of local_group  #####

gid=$(ldapsearch -x -LLL -h ldap.umich.edu -b "ou=User Groups,ou=Groups,dc=umich,dc=edu" "(cn=$lab_mcom)" gidNumber | sed -rn 's/.*gidNumber: //p')
groupadd -g $gid $local_group 
unset gid

gid2=$(ldapsearch -x -LLL -h ldap.umich.edu -b "ou=User Groups,ou=Groups,dc=umich,dc=edu" "(cn=$it_mcom)" gidNumber | sed -rn 's/.*gidNumber: //p')
groupadd -g $gid2 $local_it
unset gid2

#############################################################################################################
######### gets members of lab_mcom and it_mcom groups and concontinates them into one list ##################

lab_members=$(ldapsearch -x -LLL -h ldap.umich.edu -b "ou=User Groups,ou=Groups,dc=umich,dc=edu" "(cn=$lab_mcom)" member | sed -rn 's/.*\uid=//;s/\,ou=People.*//p')
it_members=$(ldapsearch -x -LLL -h ldap.umich.edu -b "ou=User Groups,ou=Groups,dc=umich,dc=edu" "(cn=$it_mcom)" member | sed -rn 's/.*\uid=//;s/\,ou=People.*//p')

###############################################################################################################
######### created temp text files to be read through for checking existing members vs mcomm members ###########
all_members="$lab_members $it_members"
echo $all_members >current_mcomm

current_members=$(lid -gn $local_group)
echo $current_members >local_current

###############################################################################################################
######### for loop that removes users from the local_group if they are nopt part of it or lab mcomm group #####

for uniqname in $current_members
	do
	if ! grep -q $uniqname current_mcomm
	then
		gpasswd -d $uniqname $local_group
	fi
done

###############################################################################################################
######### for loop that adds users to the group and sets permissions ##########################################

for uniqname in $all_members
	do
	if ! grep -q $uniqname local_current
	then
		uid=$(ldapsearch -x -h ldap.umich.edu -b ou=People,dc=umich,dc=edu -s one -LLL uid=$uniqname uidNumber |tail -n +2 | sed 's/.*://')
		name=$(ldapsearch -x -h ldap.umich.edu -b ou=People,dc=umich,dc=edu -s one -LLL uid=$uniqname displayName |tail -n +2 | sed 's/.*://')
	
		/usr/sbin/useradd "$uniqname"
		/usr/sbin/usermod -a -G $local_group "$uniqname"
		sed -r -i -e "s/$uniqname:x:[0-9]+:([0-9]+):[^:]*/$uniqname:x:$uid:\1:$name/" /etc/passwd
		sed -r -i -e "s/$uniqname:[^:]+:/$uniqname:!!:/" /etc/shadow
		mkdir "/home/$uniqname/"
		chown -R "$uniqname:$local_group" "/home/$uniqname/"
		chmod 700 "/home/$uniqname/"
		unset uid
		unset name
	fi
done

for uniqname in $it_members
        do
                /usr/sbin/usermod -a -G $local_it "$uniqname"
done


if [ ! -e "/etc/sudoers.d/it-admins.txt" ] ;
        then
        touch /etc/sudoers.d/it-admins.txt
        echo '%'$local_it ' ALL=(ALL:ALL) ALL' >> /etc/sudoers
fi
