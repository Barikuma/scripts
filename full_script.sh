#!/bin/bash

function create_user()
{
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
}

function create_group()
{
	groups=()

	read -p "How many groups will you like to create: " number_of_groups

	n=$((number_of_groups))

	for (( i=0; i<$n; i++ )); do
        	read -p "$((i+1)). Group name: " group_name
	        groups[$i]=$group_name
	done

	for group in ${groups[@]}; do
        	if getent group $group > /dev/null 2>&1; then
                	echo "A group with name $group already exists and cannot be created"
        	else
                	sudo groupadd $group
	                echo "Group $group has been created"
        	fi
	done
}

function add_user_group()
{
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
}

function file_acl()
{
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
}

echo "***************WELCOME***************"
echo "Choose an option"
echo "1. Create a new user"
echo "2. Create a new group"
echo "3. Add a user to a group"
echo "4. Configure a file access control list"

read -p ">> " option

case $option in
	"1")
		create_user;;
	"2")
		create_group;;
	"3")
		add_user_group;;
	"4")
		file_acl;;
	"*")
		echo "Invalid option"
		exit
		;;
esac

