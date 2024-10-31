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
                        2 "Update Home Symlinks" \
                        3 "Backup Bitwarden" \
                        Q "Quit/Back" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1)
                show_dialog_message msgbox "Backing up Syncthing Directory (excluding git_repos and Sync_Everywhere)..."
                sudo rclone sync --links --exclude "git_repos/**" --exclude "Sync_Everywhere/**" /Users/akunito/syncthing/ pcloudCrypt:/SYNC_SAFE/Syncthing -P
                wait_for_user_input
                ;;
            2)
                show_dialog_message msgbox "Updating Home Symlinks..."
                $SELF_PATH/functions/Home_Symlinks_Gen.sh
                wait_for_user_input
                ;;
            3)
                show_dialog_message msgbox "Backing up Bitwarden..."
                $SELF_PATH/functions/bitwarden_backup.sh
                wait_for_user_input
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