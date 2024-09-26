#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 <username>"
	exit 1
fi

username=$1

if getent passwd $username > /dev/null 2>&1; then
	sudo userdel -r $username
	echo "User has been deleted."
else
	echo "User does not exist"
fi

