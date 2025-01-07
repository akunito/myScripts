#!/bin/sh

echo "======================== Local Backup for Agalaptop =========================="
export RESTIC_REPOSITORY="/home/aga/.maintenance/Backups/"
export RESTIC_PASSWORD_FILE="/home/aga/.maintenance/passwords/restic.key"

# Remember that for new repository, you need to run `$ restic init -r /path/new/repo` once.

/run/wrappers/bin/restic backup ~/ \
--exclude .maintenance \
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
--exclude .trash/ --exclude .Trash/ --exclude trash/ --exclude Trash/ --exclude */.trash/ --exclude */.Trash/ --exclude */trash/ --exclude */Trash/ \
-r $RESTIC_REPOSITORY \
-p $RESTIC_PASSWORD_FILE

echo "Maintenance"
/run/wrappers/bin/restic forget --keep-daily 7 --keep-weekly 2 --keep-monthly 1 --prune \
-r $RESTIC_REPOSITORY \
-p $RESTIC_PASSWORD_FILE