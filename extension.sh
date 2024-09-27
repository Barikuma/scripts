#!/bin/bash

for file in *.*; do
	if [ -f "$file" ]; then
		extension="${file##*.}"

		if [ ! -d "$extension" ]; then
			mkdir "$extension"
			mv *."$extension" ./"$extension"
		fi
	fi
done

