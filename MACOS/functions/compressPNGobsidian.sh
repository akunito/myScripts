#!/bin/bash

# Assign the first argument to DIR variable
DIR="/Users/akunito/syncthing/My_Notes/"

# Check if the directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory does not exist."
  exit 1
fi

# # Loop through all PNG files <in the directory>
# for file in "$DIR"/*.png; do
#   if [ -f "$file" ]; then
#     echo "Compressing $file..."
#     pngquant --ext .png --quality=30-45 --force "$file"
#   else
#     echo "No PNG files found in the directory."
#   fi
# done

# Loop through all PNG files <in the directory and its subdirectories>
find "$DIR" -type f -name "*.png" | while read -r file; do
  echo "Compressing $file..."
  pngquant --ext .png --quality=30-45 --force "$file"
done

echo "Compression completed."