#!/bin/bash
# menu_Backups.sh

# Ensure dialog is installed
if ! command -v dialog &>/dev/null; then
    echo "The 'dialog' utility is not installed. Please install it and run this script again."
    exit 1
fi

SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/menu_functions.sh

perform_backup() {
    local backup_type="$1"
    
    case $backup_type in
        "mysyncthing")
            # Backup to pCloudCrypt
            # sudo rclone sync --links --exclude "git_repos/**" --exclude "Sync_Everywhere/**" /Users/akunito/syncthing/ pcloudCrypt:/SYNC_SAFE/Syncthing -P
            # wait_for_user_input

            echo -e "\n======================== Backup my Syncthing to DATA_4TB =========================="
            eval $server_DATA_4TB_MOUNT
            command=$(sync_directory_to_backup_efficiently "/Users/akunito/syncthing/" "/Users/akunito/Volumes/sshfs/Data_4TB/backups/MacBookPro/Syncthing.BAK/" \
            ".trash .Trash trash Trash */.trash */.Trash */trash */Trash Sync_Everywhere/**")
            eval "$command"
            ;;
        "myhome")
            echo -e "\n======================== Backup my Home to DATA_4TB =========================="
            eval $server_DATA_4TB_MOUNT
            command=$(sync_directory_to_backup_efficiently "/Users/akunito/" "/Users/akunito/Volumes/sshfs/Data_4TB/backups/MacBookPro/Home.BAK/" \
            ".cache .Cache cache Cache */.cache */.Cache */cache */Cache .trash .Trash trash Trash */.trash */.Trash */trash */Trash \
            .cursor/extensions/* .vscode/extensions/* .tldrc pCloudDrive pCloud* \
            Applications Desktop Documents Downloads Library Movies Music Pictures Public syncthing Syncthing Volumes")
            eval "$command"
            ;;
        "mybitwarden")
            echo -e "\n======================== Backup my Bitwarden to pCloudCrypt =========================="
            $SELF_PATH/functions/bitwarden_backup.sh
            ;;
        "HomeLab_Home")
            echo -e "\n======================== Backup HomeLab's Home to DATA_4TB =========================="
            command=$(sync_directory_to_backup_efficiently "/home/akunito/" "/mnt/DATA_4TB/backups/NixOS_homelab/Home.BAK/" \
            ".cache .Cache cache Cache */.cache */.Cache */cache */Cache .trash .Trash trash Trash */.trash */.Trash */trash */Trash")
            ssh_command "$SSH_Server" "HomeLab" "$command"
            ;;
        "AgaLaptop_Home")
            echo -e "\n======================== Backup AgaLaptop's Home to DATA_4TB =========================="
            echo "======== 1/2: Backing up locally ..."
            command=$(sync_directory_to_backup_efficiently "/home/aga/" "/home/aga/.Backups/Home.BAK/" \
            ".cache .Cache cache Cache */.cache */.Cache */cache */Cache .trash .Trash trash Trash */.trash */.Trash */trash */Trash \
            .tldrc \
            pCloudDrive .Backups */bottles Desktop Downloads Videos")
            ssh_command "$SSH_LaptopAga" "AgaLaptop" "$command"

            echo -e "\n======== 2/2: Backing up to DATA_4TB ..."
            eval $server_DATA_4TB_MOUNT
            eval $agalaptop_HOME_MOUNT && sleep 2
            command=$(sync_directory_to_backup_efficiently "/Users/akunito/Volumes/sshfs/agalaptop_home/.Backups/Home.BAK" "/Users/akunito/Volumes/sshfs/Data_4TB/backups/AgaLaptop/Home.BAK")
            eval "$command"
            ;;
        "DATA_4TB_to_pCloudCrypt")
            echo -e "\n======================== Backup DATA_4TB to pCloudCrypt =========================="
            # TODO: Implement this
            ;;
        "all")
            perform_backup "mysyncthing"
            perform_backup "myhome"
            perform_backup "mybitwarden"
            perform_backup "HomeLab_Home"
            perform_backup "AgaLaptop_Home"
            perform_backup "DATA_4TB_to_pCloudCrypt"
            ;;
    esac
}

backup_menu() {
    local choice

    while true; do
        choice=$(dialog --clear --backtitle "Backups" --title "Backups Menu" \
                        --menu "Choose an option" 15 50 3 \
                        1 "Backup All" \
                        2 "Backup my Syncthing Directory" \
                        3 "Backup my Home Directory" \
                        4 "Backup my Bitwarden" \
                        5 "Backup HomeLab's Home Directory" \
                        6 "Backup AgaLaptop's Home Directory" \
                        7 "Backup DATA_4TB to pCloudCrypt" \
                        Q "Quit/Back" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1)
                perform_backup "all"
                wait_for_user_input
                ;;
            2)
                perform_backup "mysyncthing"
                wait_for_user_input
                ;;
            3)
                perform_backup "myhome"
                wait_for_user_input
                ;;
            4)
                perform_backup "mybitwarden"
                wait_for_user_input
                ;;
            5)
                perform_backup "HomeLab_Home"
                wait_for_user_input
                ;;
            6)
                perform_backup "AgaLaptop_Home"
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