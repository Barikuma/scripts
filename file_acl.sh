#!/bin/bash

while true; do
	read -p "Group to permit: " group_name

	if ! getent group "$group_name" > /dev/null 2>&1; then
		echo "Group $group_name does not exist."
		continue
	fi
	
	read -p "(F)ile or (D)irectory (f/d): " file_type

	if [ "$file_type" == "d" ]; then

		read -p "Directory: " file

		if [ ! -d "$file" ]; then
			echo "$file is not an existing directory."
			continue
		fi
	elif [ "$file_type" == "f" ]; then

		read -p "File: " file

		if [ ! -f "$file" ]; then
			echo "$file is not an existing file."
			continue
		fi
	else
		echo "Enter either f or d"
		continue
	fi

	read -p "Permission for group $group_name: " permission

	setfacl -m g:"$group_name":"$permission" "$file"

	read -p "Enter q to quit or c to contnue: " action

	if [ "$action" == "q" ]; then
		break
	fi
done

