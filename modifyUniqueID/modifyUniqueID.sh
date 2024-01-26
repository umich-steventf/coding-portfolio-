#!/bin/bash
if [[ $USER != "root" ]]; then
	echo "before funning script please elevate terminal window with command: sudo -s"
exit 1;
fi
./test.sh -q > mappings.txt
./test.sh -m -f mappings.txt
