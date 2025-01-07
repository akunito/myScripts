#!/bin/bash

echo "Sourcing variables from $VARIABLES_PATH"
source $VARIABLES_PATH
source $MENU_FUNCTIONS_SH


bitwarden_backup() {
    # Get password from keychain
    local ENCRYPT_KEY=$(get_system_password "bitwarden2")

    # Check if encryption key exists
    if [[ -z "$ENCRYPT_KEY" ]]; then
        echo "Error: No encryption key found in keychain. Backup aborted."
        exit 1
    fi

    ENCRYPT_KEY_FILE="/tmp/bitwarden_encrypt_key"
    echo $ENCRYPT_KEY > $ENCRYPT_KEY_FILE

    # Set up a trap to remove the encryption key file on exit
    trap 'rm -f $ENCRYPT_KEY_FILE' EXIT

    # Attempt to unlock Bitwarden session
    export BW_SESSION=$(bw unlock --raw --passwordfile $ENCRYPT_KEY_FILE)

    BACKUP_PATH="$SYNCTHING_PATH/myLibrary/MySecurity/Bitwarden"
    BACKUP_FILENAME="bitwarden_backup_$(date +%F).json"

    # Export vault data using BW_SESSION
    bw sync --session $BW_SESSION  # Optional: sync vault to ensure latest data
    bw export --format json --output "$BACKUP_PATH/$BACKUP_FILENAME" --session $BW_SESSION

    # Encrypt the backup
    openssl enc -aes-256-cbc -salt -pbkdf2 -in "$BACKUP_PATH/$BACKUP_FILENAME" -out "$BACKUP_PATH/$BACKUP_FILENAME.enc" -pass pass:$encryption_key
    rm "$BACKUP_PATH/$BACKUP_FILENAME"  # Remove unencrypted backup
    echo "Backup completed and encrypted: $BACKUP_PATH/$BACKUP_FILENAME.enc"
}

bitwarden_backup
