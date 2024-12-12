#!/bin/sh

# Define sudo command based on mode
# Usage: $0 [path] [profile] <sudo_password>
if [ -n "$1" ]; then
    SUDO_PASS="$1"
    sudo_exec() {
        echo "$SUDO_PASS" | sudo -S "$@" 2>/dev/null
    }
    SUDO_CMD="sudo_exec"
else
    sudo_exec() {
        sudo "$@"
    }
    SUDO_CMD="sudo_exec"
fi

$SUDO_CMD echo -e "\nActivating sudo password for this session"

echo "======================== 1/3 Backup Locally =========================="
sleep 2
$SUDO_CMD rsync -avpP --delete --delete-excluded \
--exclude .com.apple.backupd* --exclude *.sock --exclude */dev/* --exclude .DS_Store --exclude */.DS_Store --exclude .tldrc \
--exclude .cache/ --exclude .Cache/ --exclude cache/ --exclude Cache/ --exclude */.cache/ --exclude */.Cache/ --exclude */cache/ --exclude */Cache/ \
--exclude .trash/ --exclude .Trash/ --exclude trash/ --exclude Trash/ --exclude */.trash/ --exclude */.Trash/ --exclude */trash/ --exclude */Trash/ \
/home/akunito/ /mnt/DATA_4TB/backups/NixOS_homelab/Home.BAK/

echo "======================== 2/3 Backup Locally =========================="
sleep 2
$SUDO_CMD rsync -avpP --delete --delete-excluded \
--exclude Warehouse \
--exclude Machines/ISOs \
--exclude .com.apple.backupd* --exclude *.sock --exclude */dev/* --exclude .DS_Store --exclude */.DS_Store --exclude .tldrc \
--exclude .cache/ --exclude .Cache/ --exclude cache/ --exclude Cache/ --exclude */.cache/ --exclude */.Cache/ --exclude */cache/ --exclude */Cache/ \
--exclude .trash/ --exclude .Trash/ --exclude trash/ --exclude Trash/ --exclude */.trash/ --exclude */.Trash/ --exclude */trash/ --exclude */Trash/ \
/mnt/DATA_4TB/ /mnt/HDD_4TB/BACKUP/

echo "======================== 3/3 Backup Locally =========================="
sleep 2
$SUDO_CMD rsync -avpP --delete --delete-excluded \
--exclude .com.apple.backupd* --exclude *.sock --exclude */dev/* --exclude .DS_Store --exclude */.DS_Store --exclude .tldrc \
--exclude .cache/ --exclude .Cache/ --exclude cache/ --exclude Cache/ --exclude */.cache/ --exclude */.Cache/ --exclude */cache/ --exclude */Cache/ \
--exclude .trash/ --exclude .Trash/ --exclude trash/ --exclude Trash/ --exclude */.trash/ --exclude */.Trash/ --exclude */trash/ --exclude */Trash/ \
/mnt/DATA_4TB/Warehouse/Books/ /mnt/HDD_4TB/BACKUP/Warehouse/Books/


# HDD_4TB/BACKUP/ to pcloudCrypt:/SYNC_SAFE/BACKUP/
echo "======================== 1/1 Backup Remotelly =========================="
sleep 2
rclone sync --links -P --stats=1s \
--exclude *.iso \
--exclude *.sparsebundle/ \
--exclude Warehouse/Media \
--exclude Warehouse/downloads \
--exclude Machines/ISOs \
--exclude .com.apple.backupd* --exclude *.sock --exclude */dev/* --exclude .DS_Store --exclude */.DS_Store --exclude .tldrc \
--exclude .cache/ --exclude .Cache/ --exclude cache/ --exclude Cache/ --exclude */.cache/ --exclude */.Cache/ --exclude */cache/ --exclude */Cache/ \
--exclude .trash/ --exclude .Trash/ --exclude trash/ --exclude Trash/ --exclude */.trash/ --exclude */.Trash/ --exclude */trash/ --exclude */Trash/ \
--exclude */cache.db \
/mnt/HDD_4TB/BACKUP/ pcloudCrypt:/SYNC_SAFE/BACKUP/