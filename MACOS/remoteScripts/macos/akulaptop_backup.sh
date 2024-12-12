#!/bin/bash

# # Include VARIABLES.sh
# source $VARIABLES_PATH
# # Include NETWORK.sh
# source $NETWORK_PATH

echo "======================== Backing up Locally to MyLibrary connected with Nextcloud =========================="
sleep 2

sudo rsync -avpP --delete --delete-excluded \
--exclude ".com.apple.backupd*" --exclude "*.sock" --exclude "*/dev/*" --exclude ".DS_Store" --exclude ".tldrc/" --exclude ".cache/" --exclude ".Cache/" --exclude "cache/" \
--exclude "Cache/" --exclude "*/.cache/" --exclude "*/.Cache/" --exclude "*/cache/" --exclude "*/Cache/" --exclude ".trash/" --exclude ".Trash/" --exclude "trash/" \
--exclude "Trash/" --exclude "*/.trash/" --exclude "*/.Trash/" --exclude "*/trash/" --exclude "*/Trash/" \
--exclude "pCloudDrive/" --exclude "pCloud Drive/" --exclude "syncthing/" --exclude "Applications/" --exclude "Desktop/" --exclude "Documents/" --exclude "Downloads/" --exclude "Library/" \
--exclude "Movies/" --exclude "Music/" --exclude "Pictures/" --exclude "Public/" --exclude "Volumes/" \
"/Users/akunito/" "/Users/akunito/syncthing/myLibrary/MyBackups/Home.BAK/"

# THIS HAVE BEEN REPLACED BY TIME MACHINE