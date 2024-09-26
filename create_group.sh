#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 <group name>"
	exit 1
fi

group=$1

if getent group "$group" > /dev/null 2>&1; then
	echo "Group already exists."
else
	sudo groupadd "$group"
	echo "Group created."
fi
