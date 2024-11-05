#!/bin/bash

echo "Sourcing variables from $VARIABLES_PATH"
source $VARIABLES_PATH

bitwarden_backup() {
  # Variables
  export BW_SESSION=$(bw unlock --raw)
  BACKUP_PATH="$SYNCTHING_PATH/myLibrary/MySecurity/Bitwarden"
  PCLOUD_PATH="/SYNC_SAFE/backups/MacBookPro/Home.BAK/syncthing/myLibrary/MySecurity/Bitwarden"
  BACKUP_FILENAME="bitwarden_backup_$(date +%F).json"

  # Check if BW_SESSION is set
  if [[ -z "$BW_SESSION" ]]; then
      echo "Error: BW_SESSION is not set. Please log in and set the BW_SESSION environment variable."
      exit 1
  fi

  # Prompt the user for the encryption key, checking for a match
  while true; do
      read -sp "Enter encryption key: " ENCRYPT_KEY_1
      echo ""
      read -sp "Confirm encryption key: " ENCRYPT_KEY_2
      echo ""
      
      if [[ "$ENCRYPT_KEY_1" == "$ENCRYPT_KEY_2" ]]; then
          ENCRYPT_KEY="$ENCRYPT_KEY_1"
          break
      else
          echo "Error: The encryption keys do not match. Please try again."
      fi
  done

  # Export vault data using BW_SESSION
  bw sync --session $BW_SESSION  # Optional: sync vault to ensure latest data
  bw export --format json --output "$BACKUP_PATH/$BACKUP_FILENAME" --session $BW_SESSION

  # Encrypt the backup
  if [[ -n "$ENCRYPT_KEY" ]]; then
      openssl enc -aes-256-cbc -salt -pbkdf2 -in "$BACKUP_PATH/$BACKUP_FILENAME" -out "$BACKUP_PATH/$BACKUP_FILENAME.enc" -pass pass:$ENCRYPT_KEY
      rm "$BACKUP_PATH/$BACKUP_FILENAME"  # Remove unencrypted backup
      echo "Backup completed and encrypted: $BACKUP_PATH/$BACKUP_FILENAME.enc"
  else
      echo "No encryption key provided. Backup saved without encryption: $BACKUP_PATH/$BACKUP_FILENAME"
  fi

  # Sync with rclone to pCloud
  if rclone sync "$BACKUP_PATH" "pcloudCrypt:$PCLOUD_PATH"; then
      echo "rclone sync successful."

      # Check if the file is listed in pCloud
      if rclone ls "pcloudCrypt:$PCLOUD_PATH" | grep -q "$(basename "$BACKUP_PATH/$BACKUP_FILENAME.enc")"; then
          echo "Backup file is confirmed to be present on pCloud."
          rm "$BACKUP_PATH/$BACKUP_FILENAME.enc"  # Remove encrypted local backup
      else
          echo "Backup file was not found in pCloud. Please check manually."
      fi

      # Remove older backups, keeping only the latest 5
      backup_count=$(rclone lsf "pcloudCrypt:$PCLOUD_PATH" | grep -E 'bitwarden_backup_[0-9]{4}-[0-9]{2}-[0-9]{2}.json.enc' | wc -l)
      if [ "$backup_count" -gt 5 ]; then
          files_to_delete=$(rclone lsf "pcloudCrypt:$PCLOUD_PATH" | grep -E 'bitwarden_backup_[0-9]{4}-[0-9]{2}-[0-9]{2}.json.enc' | sort | head -n -5)
          for file in $files_to_delete; do
              echo "Removing old backup file: $file"
              rclone delete "pcloudCrypt:$PCLOUD_PATH/$file"
          done
      fi
  else
      echo "rclone sync failed. Retaining encrypted backup for troubleshooting."
  fi
}

bitwarden_backup
