#!/bin/bash

modifySingle=0

while getopts ":hlqmsf:" opt; do
  case $opt in
    h)
        operation="help"
        ;;
    l)
	operation="list" 
        ;;
    q)
        operation="query"
	;;
    m)
        operation="modify"
        ;;
    f)
        filePath="$OPTARG"
        ;;
    s)
	modifySingle=1
        ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done


if [[ $operation = "modify"  && -z ${filePath} && modifySingle = 0 ]]; then
	echo "Please provide the path to the mappings file: -f <path to file>"
	exit 0;
fi

function listUsernames {
        dscl /Local/Default -list /Users uid | awk '$2 >= 100 && $0 !~ /^_/ { print $1 }'
}

function displayHelp {
	echo ""
	echo "modifyUniqueID v.1.1"
	echo ""
	echo "List non-system user accounts..."
	echo "modifyUniqueID.sh -l"
	echo ""
	echo "Query MCommunity for the uid number of visible users on the system. Outputs in a tab-delimited list the username and the uid"
	echo "modifyUniqueID.sh -q"
	echo ""
	echo "Reads in a file containing a list of tab-delimited username and uid pairs, changes the UniqueID numbers of users on the system to those provided in the file, and sets disk file permissions appropriately..."
	echo "modifyUniqueID.sh -m -f mapping.txt" 	
	echo ""
}

function queryUserIDs {

	userlist=$(dscl /Local/Default -list /Users uid | awk '$2 >= 100 && $0 !~ /^_/ { print $1 }')

	while read -r username; do
		uid=$(ldapsearch -h ldap.umich.edu -xb "ou=People,dc=umich,dc=edu"  "(uid=${username})" uidNumber | sed -n 's/^[ \t]*uidNumber:[ \t]*\(.*\)/\1/p')
		echo -e "${username}\t${uid}"
		
	done <<< "$userlist"
}

function queryUserIDs2 {

	while read uniqname;do	
		
		# Query to get the UniqueID, which is returned in the format "UniqueID: xxxx"
                queryresult=$(dscl /LDAPv3/ldap.umich.edu -read /Users/${uniqname}  UniqueID) &> /dev/null
		
		# Parse the result to get the number
                UniqueID="$( cut -d ':' -f 2- <<< "$queryresult" )"; echo "$uniqueID" &> /dev/null		

		echo  -e "${uniqname}\t${UniqueID}"

	done < $filePath	 
}

function modifyUniqueIDs {
	
	echo "Reading data file..."

	while read a b;do 

		uniqname=$a 
		newUniqueID=$b
	
		echo "Processsing ${uniqname}..."
	
		# Query to get the original UniqueID, which is returned in the format "UniqueID: xxxx" 
		queryresult=$(dscl . -read /Users/${uniqname}  UniqueID) 

		# Parse the result to get the number 
		originalUniqueID="$( cut -d ':' -f 2- <<< "$queryresult" )"; echo "$uniqueID"

		# Change the user's original UniqueID to the new UniqueID 
		echo "Changing ${originalUniqueID} to ${newUniqueID}..."
		commandresult=$(dscl . -change /Users/${uniqname} UniqueID ${originalUniqueID} ${newUniqueID})

		# Find all files on the root partition and change the permissions accordingly
		echo "Updating file permissions..."
		commandresult=$(find -xP / -user ${originalUniqueID}  -print0 | xargs -0 chown -h ${newUniqueID})

	done < $filePath
}

if [[ $operation = "help" ]]; then
        displayHelp
elif [[ $operation = "list" ]]; then
       	listUsernames 
elif [[ $operation = "query" ]]; then
        queryUserIDs
elif [[ $operation = "modify" ]]; then
        modifyUniqueIDs
fi

