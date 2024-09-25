#!/bin/bash

users=()

read -p "How many users do you want to create: " number_of_users

n=$((number_of_users))

for (( i=0; i<$n; i++ )); do
	read -p "User $((i+1)): " username
	users[$i]=$username
done

for name in ${users[@]}; do
	if getent passwd $name > /dev/null 2>&1; then
		echo "$name is an existing user"
	else
		read -p "Password for user $name: " -s password
		
		useradd -m $name
		echo "$name:$password" | chpasswd
		echo 	
		echo "User $name has been created"
	fi
done
