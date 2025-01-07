#!/bin/sh

echo "======================== 3/3 Backup Remotelly ==========================" && sleep 2
# rclone sync --links -P --stats=1s \
# --exclude *.iso \
# --exclude *.sparsebundle/ \
# --exclude Warehouse/Media \
# --exclude Warehouse/downloads \
# --exclude Machines/ISOs \
# --exclude .com.apple.backupd* --exclude *.sock --exclude */dev/* --exclude .DS_Store --exclude */.DS_Store --exclude .tldrc \
# --exclude .cache/ --exclude .Cache/ --exclude cache/ --exclude Cache/ --exclude */.cache/ --exclude */.Cache/ --exclude */cache/ --exclude */Cache/ \
# --exclude .trash/ --exclude .Trash/ --exclude trash/ --exclude Trash/ --exclude */.trash/ --exclude */.Trash/ --exclude */trash/ --exclude */Trash/ \
# --exclude */cache.db --exclude */readarr/logs.db \
# /mnt/HDD_4TB/BACKUP/ pcloudCrypt:/SYNC_SAFE/BACKUP/


sudo rsync -rltpD -vP --delete --delete-excluded \
--exclude *.iso \
--exclude *.sparsebundle/ \
--exclude Warehouse/Media \
--exclude Warehouse/downloads \
--exclude Machines/ISOs \
--exclude .com.apple.backupd* --exclude *.sock --exclude */dev/* --exclude .DS_Store --exclude */.DS_Store --exclude .tldrc \
--exclude .cache/ --exclude .Cache/ --exclude cache/ --exclude Cache/ --exclude */.cache/ --exclude */.Cache/ --exclude */cache/ --exclude */Cache/ \
--exclude .trash/ --exclude .Trash/ --exclude trash/ --exclude Trash/ --exclude */.trash/ --exclude */.Trash/ --exclude */trash/ --exclude */Trash/ \
--exclude */cache.db --exclude */readarr/logs.db \
/mnt/HDD_4TB/BACKUP/ pcloudCrypt:/SYNC_SAFE/BACKUP/
