#!/bin/bash
# menu_Backups.sh

# Ensure dialog is installed
if ! command -v dialog &>/dev/null; then
    echo "The 'dialog' utility is not installed. Please install it and run this script again."
    exit 1
fi

SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/menu_functions.sh

backup_by_ssh() {
    local ssh_connection="$1"
    local system_name="$2"
    local script_path="$3"

    # Get password from keychain
    local password=$(get_system_password "$system_name")
    if [ $? -ne 0 ]; then
        show_dialog_message msgbox "Password operation cancelled"
        return 1
    fi

    ssh_interactive_command "$ssh_connection" "sh \"$script_path\" \"$password\"" # we pass as $1 argument the password
}

perform_backup() {
    local backup_type="$1"
    
    case $backup_type in
        "myhome")
            echo -e "\n======================== Backup my Laptop =========================="
            eval $server_DATA_4TB_MOUNT
            eval $server_MACAKUBACKUP_MOUNT
            echo "======== Check your TIME MACHINE GUI to automate backups !"
            echo "======== Listing local snapshots ..."
            tmutil listlocalsnapshots /Volumes/TimeMachineBackup
            sleep 2
            ;;
        "mybitwarden")
            echo -e "\n======================== Backup my Bitwarden to pCloudCrypt =========================="
            $SELF_PATH/functions/bitwarden_backup.sh
            ;;
        "AgaLaptop_Home")
            echo -e "\n======================== Backup AgaLaptop's Home to local directory =========================="
            # echo "======== Uploading script to server ..." && sleep 2
            # scp $SELF_PATH/remoteScripts/nixos/agalaptop_backup.sh $agalaptop_USER@$IP_LaptopAga_WIFI:/home/aga/myScripts/
            # echo "======== Running script on server ..." && sleep 2
            backup_by_ssh "$SSH_LaptopAga" "AgaLaptop" "/home/aga/myScripts/agalaptop_backup.sh"
            echo "======== DONE. The local backup will be sync to Nextcloud."
            ;;
        "HomeLab_backups")
            echo -e "\n======================== Backup Home && DATA_4TB locally && to cloud =========================="
            # echo "======== Uploading script to server ..." && sleep 2
            # scp $SELF_PATH/remoteScripts/nixos/homelab_backup.sh $server_USER@$IP_Server_ETH:/home/akunito/myScripts/
            # echo "======== Running script on server ..." && sleep 2
            backup_by_ssh "$SSH_Server" "HomeLab" "/home/akunito/myScripts/homelab_backup.sh"
            ;;
        "all")
            perform_backup "myhome"
            perform_backup "AgaLaptop_Home"
            perform_backup "HomeLab_backups"
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
                        4 "Backup AgaLaptop's Home" \
                        5 "Backup HomeLab backups" \
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
                perform_backup "AgaLaptop_Home"
                wait_for_user_input
                ;;
            5)
                perform_backup "HomeLab_backups"
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