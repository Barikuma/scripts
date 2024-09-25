#!/bin/bash

groups=()

read -p "How many groups will you like to create: " number_of_groups

n=$((number_of_groups))

for (( i=0; i<$n; i++ )); do
	read -p "$((i+1)). Group name: " group_name
	groups[$i]=$group_name
done

for group in ${groups[@]}; do
	if getent group $group > /dev/null 2>&1; then
		echo "A gorup with name $group already exists and cannot be created"
	else
		sudo groupadd $group
		echo "Group $group has been created"
	fi
done


