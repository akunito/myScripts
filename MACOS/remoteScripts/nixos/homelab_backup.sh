#!/bin/sh

echo "======================== 1/2 Backup Homelab's home ==========================" && sleep 2
export RESTIC_REPOSITORY=/mnt/DATA_4TB/backups/NixOS_homelab/Home.restic/
export RESTIC_PASSWORD_FILE="/home/akunito/myScripts/restic.key"

/run/wrappers/bin/restic backup /home/akunito/ \
--exclude .com.apple.backupd* --exclude *.sock --exclude */dev/* --exclude .DS_Store --exclude */.DS_Store --exclude .tldrc \
--exclude .cache/ --exclude .Cache/ --exclude cache/ --exclude Cache/ --exclude */.cache/ --exclude */.Cache/ --exclude */cache/ --exclude */Cache/ \
--exclude .trash/ --exclude .Trash/ --exclude trash/ --exclude Trash/ --exclude */.trash/ --exclude */.Trash/ --exclude */trash/ --exclude */Trash/ \

echo "Maintenance of repo"
restic forget --keep-daily 7 --keep-weekly 2 --keep-monthly 1 --prune


echo "======================== 2/2 Backup DATA_4TB ==========================" && sleep 2
sudo rsync -avpP --delete --delete-excluded \
--exclude Warehouse/Media \
--exclude Warehouse/Movies \
--exclude Warehouse/downloads \
--exclude Machines/ISOs \
--exclude .com.apple.backupd* --exclude *.sock --exclude */dev/* --exclude .DS_Store --exclude */.DS_Store --exclude .tldrc \
--exclude .cache/ --exclude .Cache/ --exclude cache/ --exclude Cache/ --exclude */.cache/ --exclude */.Cache/ --exclude */cache/ --exclude */Cache/ \
--exclude .trash/ --exclude .Trash/ --exclude trash/ --exclude Trash/ --exclude */.trash/ --exclude */.Trash/ --exclude */trash/ --exclude */Trash/ \
--exclude */cache.db --exclude */readarr/logs.db \
/mnt/DATA_4TB/ /mnt/HDD_4TB/BACKUP/
