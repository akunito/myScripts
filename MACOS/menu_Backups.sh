#!/bin/bash
# menu_Backups.sh

# Ensure dialog is installed
if ! command -v dialog &>/dev/null; then
    echo "The 'dialog' utility is not installed. Please install it and run this script again."
    exit 1
fi

SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")

backup_menu() {
    local choice

    while true; do
        choice=$(dialog --clear --backtitle "Backups" --title "Backups Menu" \
                        --menu "Choose an option" 15 50 3 \
                        1 "Backup Syncthing Directory" \
                        2 "Backup Bitwarden" \
                        Q "Quit/Back" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1)
                show_dialog_message infobox "Backing up Syncthing Directory..." 5
                sudo rclone sync /Users/akunito/syncthing/ pcloudCrypt:/SYNC_SAFE/Syncthing
                ;;
            2)
                show_dialog_message infobox "Backing up Bitwarden..." 5
                $SELF_PATH/functions/bitwarden_backup.sh
                ;;
            Q|q)
                break
                ;;
            *)
                show_dialog_message msgbox "Invalid option"
                ;;
        esac
    done
}

backup_menu