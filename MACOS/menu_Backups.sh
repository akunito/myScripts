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
            "pCloudDrive/ pCloud*/ */git_repos/ */Sync_Everywhere/ \
            Applications/ Desktop/ Documents/ Downloads/ Library/ Movies/ Music/ Pictures/ Public/ Volumes/")
            eval "$command"
            ;;
        "mybitwarden")
            echo -e "\n======================== Backup my Bitwarden to pCloudCrypt =========================="
            $SELF_PATH/functions/bitwarden_backup.sh
            ;;
        "HomeLab_Home")
            echo -e "\n======================== Backup HomeLab's Home to DATA_4TB =========================="
            command=$(sync_directory_to_backup_efficiently "/home/akunito/" "/mnt/DATA_4TB/backups/NixOS_homelab/Home.BAK/" \
            "")
            ssh_command "$SSH_Server" "HomeLab" "$command"
            ;;
        "AgaLaptop_Home")
            echo -e "\n======================== Backup AgaLaptop's Home to DATA_4TB =========================="
            echo "======== 1/2: Backing up locally ..."
            command=$(sync_directory_to_backup_efficiently "/home/aga/" "/home/aga/.Backups/Home.BAK/" \
            "pCloudDrive/ .Backups/ */bottles/ Desktop/ Downloads/ Videos/")
            ssh_command "$SSH_LaptopAga" "AgaLaptop" "$command"

            echo -e "\n======== 2/2: Backing up to DATA_4TB ..."
            eval $server_DATA_4TB_MOUNT
            eval $agalaptop_HOME_MOUNT && sleep 2
            command=$(sync_directory_to_backup_efficiently "/Users/akunito/Volumes/sshfs/agalaptop_home/.Backups/Home.BAK/" "/Users/akunito/Volumes/sshfs/Data_4TB/backups/AgaLaptop/Home.BAK/")
            eval "$command"
            ;;
        "DATA_4TB_to_pCloudCrypt")
            echo -e "\n======================== Backup DATA_4TB to pCloudCrypt =========================="
            echo "======== 1/3: Backing up /backups ..."
            echo "(Skipping TimeMachine '.sparsebundle' backups)"
            command="rclone sync --links -P --stats=1s --exclude \"*.sparsebundle/\" --exclude \"ArchLinux_HostServer/\" \
            \"/mnt/DATA_4TB/backups/\" \"pcloudCrypt:/SYNC_SAFE/backups/\""
            echo "command: $command"
            sleep 8
            ssh_command "$SSH_Server" "DATA_4TB" "$command" --no-log
            sleep 8
            echo -e "======== 2/3: Backing up /Machines ..."
            command="rclone sync --links -P --stats=1s --exclude \"*.iso\" --exclude \"ISOs/\" \"/mnt/DATA_4TB/Machines/\" \"pcloudCrypt:/SYNC_SAFE/Machines/\""
            echo "command: $command"
            sleep 8
            ssh_command "$SSH_Server" "DATA_4TB" "$command" --no-log
            sleep 8

            echo -e "======== 3/3: Backing up /Warehouse ..."
            command="rclone sync --links -P --stats=1s \"/mnt/DATA_4TB/Warehouse/\" \"pcloudCrypt:/SYNC_SAFE/Warehouse/\""
            echo "command: $command"
            sleep 8
            ssh_command "$SSH_Server" "DATA_4TB" "$command" --no-log
            sleep 8
            ;;
        "all")
            perform_backup "myhome"
            perform_backup "HomeLab_Home"
            perform_backup "AgaLaptop_Home"
            perform_backup "DATA_4TB_to_pCloudCrypt"
            perform_backup "mybitwarden"
            ;;
    esac
}

backup_menu() {
    local choice

    while true; do
        choice=$(dialog --clear --backtitle "Backups" --title "Backups Menu" \
                        --menu "Choose an option" 15 50 3 \
                        1 "Backup EVERYTHING" \
                        2 "Backup my Home" \
                        3 "Backup my Bitwarden" \
                        4 "Backup HomeLab's Home" \
                        5 "Backup AgaLaptop's Home" \
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
            6)
                perform_backup "DATA_4TB_to_pCloudCrypt"
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