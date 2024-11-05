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
        "myhome")
            echo -e "\n======================== Backup my Home to DATA_4TB =========================="
            eval $server_DATA_4TB_MOUNT
            command=$(sync_directory_to_backup_efficiently "/Users/akunito/" "/Users/akunito/Volumes/sshfs/Data_4TB/backups/MacBookPro/Home.BAK/" \
            ".tldrc/ .cache/ .Cache/ cache/ Cache/ */.cache/ */.Cache/ */cache/ */Cache/ .trash/ .Trash/ trash/ Trash/ */.trash/ */.Trash/ */trash/ */Trash/ \
            pCloudDrive/ pCloud*/ */git_repos/ */Sync_Everywhere/ \
            Applications/ Desktop/ Documents/ Downloads/ Library/ Movies/ Music/ Pictures/ Public/ Volumes/")
            echo "$command"
            wait_for_user_input
            eval "$command"
            ;;
        "mybitwarden")
            # TODO: TO UPDATE PATH TO SYNC_SAFE
            echo -e "\n======================== Backup my Bitwarden to pCloudCrypt =========================="
            $SELF_PATH/functions/bitwarden_backup.sh
            ;;
        "HomeLab_Home")
            echo -e "\n======================== Backup HomeLab's Home to DATA_4TB =========================="
            command=$(sync_directory_to_backup_efficiently "/home/akunito/" "/mnt/DATA_4TB/backups/NixOS_homelab/Home.BAK/" \
            ".tldrc/ .cache/ .Cache/ cache/ Cache/ */.cache/ */.Cache/ */cache/ */Cache/ .trash/ .Trash/ trash/ Trash/ */.trash/ */.Trash/ */trash/ */Trash/")
            ssh_command "$SSH_Server" "HomeLab" "$command"
            ;;
        "AgaLaptop_Home")
            echo -e "\n======================== Backup AgaLaptop's Home to DATA_4TB =========================="
            echo "======== 1/2: Backing up locally ..."
            command=$(sync_directory_to_backup_efficiently "/home/aga/" "/home/aga/.Backups/Home.BAK/" \
            ".tldrc/ .cache/ .Cache/ cache/ Cache/ */.cache/ */.Cache/ */cache/ */Cache/ .trash/ .Trash/ trash/ Trash/ */.trash/ */.Trash/ */trash/ */Trash/ \
            pCloudDrive/ .Backups/ */bottles/ Desktop/ Downloads/ Videos/")
            ssh_command "$SSH_LaptopAga" "AgaLaptop" "$command"

            echo -e "\n======== 2/2: Backing up to DATA_4TB ..."
            eval $server_DATA_4TB_MOUNT
            eval $agalaptop_HOME_MOUNT && sleep 2
            command=$(sync_directory_to_backup_efficiently "/Users/akunito/Volumes/sshfs/agalaptop_home/.Backups/Home.BAK/" "/Users/akunito/Volumes/sshfs/Data_4TB/backups/AgaLaptop/Home.BAK/")
            eval "$command"
            ;;
        "DATA_4TB_to_pCloudCrypt")
            echo -e "\n======================== Backup DATA_4TB to pCloudCrypt =========================="
            # TODO: Implement this
            ;;
        "all")
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
                        2 "Backup my Home Directory" \
                        3 "Backup my Bitwarden" \
                        4 "Backup HomeLab's Home Directory" \
                        5 "Backup AgaLaptop's Home Directory" \
                        6 "Backup DATA_4TB to pCloudCrypt" \
                        Q "Quit/Back" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1)
                perform_backup "all"
                wait_for_user_input
                ;;
            2)
                perform_backup "myhome"
                wait_for_user_input
                ;;
            3)
                perform_backup "mybitwarden"
                wait_for_user_input
                ;;
            4)
                perform_backup "HomeLab_Home"
                wait_for_user_input
                ;;
            5)
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