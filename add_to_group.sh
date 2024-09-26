#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Usage: $0 <group name> <username>"
	exit 1
fi

group=$1
username=$2

if getent group "$group" > /dev/null 2>&1; then
	
	if getent passwd "$username" > /dev/null 2>&1; then
		sudo usermod -aG $group $username	
		echo "User has been added to group."

	else
		echo "User does not exist."
	fi
else
	echo "Group does not exist."
fi

	
