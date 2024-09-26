#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 <group name>"
	exit 1
fi

group=$1

if getent group "$group" > /dev/null 2>&1; then
	read -p "Are you sure you want to delete group? (y/n): " action

	if [ "$action" == "y" ]; then
		sudo groupdel "$group"
		echo "Group deleted."
	elif [ "$action" == "n" ]; then
		echo "Delete canceled".
	else
		echo "Wrong option entered."
	fi
else
	echo "Group does not exist"
fi

