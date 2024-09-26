#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 <username>"
	exit 1
fi

username=$1

sudo useradd -m -s /bin/zsh $username

echo "User has been created"
