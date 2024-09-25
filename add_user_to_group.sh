#!/bin/bash

user_count=0
while true; do
	read -p "Enter user: " username
	
	if getent passwd "$username" > /dev/null 2>&1; then
		group_count=0
		while true; do
			read -p "Group to be a part of: " group_name

			if ! getent group "$group_name" > /dev/null 2>&1; then
				echo "Group does not exist"
				group_count=$((group_count+1))
				if [ "$group_count" -eq 3 ]; then
					echo "You have entered a wrong group name 3 times"
					echo "Exiting..."
					exit
				fi
				continue
			else
				usermod -aG "$group_name" "$username"
				echo "$username has been added to group $group_name"
			fi

			read -p "Enter q to quit or c to continue: " action

			if [ "$action" == "q" ]; then
				break
			elif [ "$action" == "c" ]; then
				continue
			else
				echo "Wrong option."
			       	echo "Exiting..."
				exit
			fi       
		done
	else
		echo "$username is not a registered username."
		user_count=$((user_count+1))

		if [ "$user_count" -eq 3 ]; then
			echo "You have entered a wrong name 3 times."
			echo "Exiting..."
			exit
		else
			continue
		fi
	fi
	
	read -p "Add more users to group (y/n): " more

	if [ "$more" == "y" ]; then
		continue
	else
		exit
	fi
done
