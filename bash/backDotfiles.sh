#!/bin/bash

# Define the destination directory for backups (replace with your desired path)
DEST_DIR="/mnt/TimeShift/ConfigBackups/homeDotfiles"

# Define paths to backup as an array (add or remove paths from here)
paths=(
    "/home/akunito/Desktop"
    # "/home/akunito/Documents"
    "/home/akunito/Pictures"
    "/home/akunito/Downloads"
    # "/home/akunito/Videos"
    # "/home/akunito/Templates"
    # "/home/akunito/Music"
    "/home/akunito/mySCRIPTS"

    "/home/akunito/.settings"
    "/home/akunito/.themes"
    "/home/akunito/.icons"
    "/home/akunito/.bashrc"
    "/home/akunito/.bash_history"
    "/home/akunito/.blerc"

    "/home/akunito/.local/share/applications"
    "/home/akunito/.local/share/blesh"
    "/home/akunito/.local/share/fonts"
    "/home/akunito/.local/share/themes"
    "/home/akunito/.local/share/rofi/themes/"

    "/home/akunito/.config"
)

# Get current date for archive naming
DATE=$(date +%Y-%m-%d)
TIME=$(date +"%H:%M:%S")

# Create archive filename with timestamp
archive_name="DotFiles_backup-${DATE}_${TIME}.tar.gz"

# Check if destination directory exists, create it if not
if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR"
fi

# Use tar to create a single compressed archive of all paths
tar -czvf "$DEST_DIR/$archive_name" "${paths[@]}"

# Print confirmation message
echo "Backup of all paths created as '$DEST_DIR/$archive_name'"
notify-send "Dotfiles Backup" "Has been copied to '$DEST_DIR/$archive_name'"

echo "setting back permissions to akunito on '$DEST_DIR/$archive_name'"
sudo chown -R akunito:akunito $DEST_DIR/$archive_name

echo "All backups completed!"
