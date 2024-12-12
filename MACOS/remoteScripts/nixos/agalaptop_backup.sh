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

echo "======================== Local Backup for Agalaptop =========================="
sleep 2

export RESTIC_REPOSITORY=/home/aga/Sync/.maintenance/Backups/
export RESTIC_PASSWORD=$($SUDO_CMD cat /home/aga/Sync/.maintenance/passwords/restic.key)

restic backup ~/ \
--exclude Warehouse \
--exclude Machines/ISOs \
--exclude pCloudDrive/ \
--exclude */bottles/ \
--exclude Desktop/ \
--exclude Downloads/ \
--exclude Videos/ \
--exclude Sync/ \
--exclude .com.apple.backupd* --exclude *.sock --exclude */dev/* --exclude .DS_Store --exclude */.DS_Store --exclude .tldrc \
--exclude .cache/ --exclude .Cache/ --exclude cache/ --exclude Cache/ --exclude */.cache/ --exclude */.Cache/ --exclude */cache/ --exclude */Cache/ \
--exclude .trash/ --exclude .Trash/ --exclude trash/ --exclude Trash/ --exclude */.trash/ --exclude */.Trash/ --exclude */trash/ --exclude */Trash/


# Cleanup old bakcups
restic forget --keep-daily 7 --keep-weekly 2 --keep-monthly 1 --prune

# List snapshots
restic snapshots

