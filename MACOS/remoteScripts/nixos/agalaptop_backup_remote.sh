#!/bin/sh

# ========================================= CONFIG =========================================
DRIVE_NAME="NFS_Backups"
SERVICE_NAME="mnt-NFS_Backups.mount"
SOURCE="/home/aga/.maintenance/Backups/"
DESTINATION="/mnt/NFS_Backups/home.restic/"

# ========================================= FUNCTIONS =========================================
# Check if NFS_Backups is mounted
get_status() {
    status=$(systemctl status $SERVICE_NAME | grep "Active:")
    echo "$status"
}

# Function to try to mount NFS_Backups using systemctl
mount_nfs_backups() {
    echo "Trying to mount $DRIVE_NAME..."
    systemctl start $SERVICE_NAME
    status=$(get_status)
    if echo "$status" | grep -q "active (mounted)"; then
        echo "$DRIVE_NAME mounted succesfully."
        return 0
    else
        echo "$DRIVE_NAME could not be mounted."
        return 1
    fi
}

replicate_repo() {
    echo "Replicating repository..."
    echo "Source: $SOURCE"
    echo "Destination: $DESTINATION"

    mkdir -p $DESTINATION

    sudo rsync -rltpD -vP --delete --delete-excluded $SOURCE $DESTINATION
}

# ========================================= MAIN =========================================
echo "======================== Remote Backup for Agalaptop =========================="

main() {
    status=$(get_status)

    if echo "$status" | grep -q "active (mounted)"; then
        echo "$DRIVE_NAME is mounted. Starting remote backup..."
        replicate_repo
    else
        echo "$DRIVE_NAME is not mounted."
        if mount_nfs_backups; then
            # Drive mounted, recall main
            main
        else
            # It failed to mount, we exit
            echo "Skipping remote backup..."
        fi
    fi
}

main