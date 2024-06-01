#!/bin/bash

# Copy Camera
ORIGEN_DIR="/run/user/1000/4df79f01_b98e_4cab_9ebd_ff0cd714cacf/storage/emulated/0/DCIM/Camera/"
DEST_DIR="/mnt/Linux_Data/Pictures/Todas\ mis\ fotos/Photos/00_2023_Realme\ RMX3311/"
# Check if destination directory exists, create it if not
if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR"
fi
# cp -vr "$ORIGEN_DIR" "$DEST_DIR"
mv -n "$ORIGEN_DIR" "$DEST_DIR"
#sudo chown -R akunito:akunito "$DEST_DIR"
echo "Camera files copied to '$DEST_DIR'"

# Copy WhatsApp Images
ORIGEN_DIR="/run/user/1000/4df79f01_b98e_4cab_9ebd_ff0cd714cacf/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp\ Images"
DEST_DIR="/mnt/Linux_Data/Pictures/Todas\ mis\ fotos/Photos/00_2023_Realme RMX3311/WhatsApp\ Images"
# Check if destination directory exists, create it if not
if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR"
fi
cp -vr "$ORIGEN_DIR" "$DEST_DIR"
#sudo chown -R akunito:akunito "$DEST_DIR"
echo "WhatsApp images copied to '$DEST_DIR'"

# Copy Telegram images
ORIGEN_DIR="/run/user/1000/4df79f01_b98e_4cab_9ebd_ff0cd714cacf/storage/emulated/0/Telegram"
DEST_DIR="/mnt/Linux_Data/Pictures/Todas\ mis\ fotos/Photos/00_2023_Realme\ RMX3311/Telegram"
# Check if destination directory exists, create it if not
if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR"
fi
cp -vr "$ORIGEN_DIR" "$DEST_DIR"
#sudo chown -R akunito:akunito "$DEST_DIR"
echo "Telegram images copied to '$DEST_DIR'"



# Print confirmation message
notify-send "Phone Files Backup" "Has been copied"
echo "Phone backup script completed!"


cp -r /run/user/1000/4df79f01_b98e_4cab_9ebd_ff0cd714cacf/storage/emulated/0/DCIM/IMG_20230315_212024.jpg ~/home/Pictures/test