#!/bin/bash

# Path to the functions file
SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/menu_functions.sh

MENU_PATH=""

main_menu() {
    local choice

    while true; do
        choice=$(dialog --clear --backtitle "Main Menu" --title "Main Menu" \
                        --menu "Choose an option" 15 50 6 \
                        1 "Update System" \
                        2 "SSHFS" \
                        3 "Compress PICS" \
                        4 "Virsh Manager" \
                        Q "Quit" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1) $SELF_PATH/menu_Update_System.sh ;;
            2) $SELF_PATH/menu_SSHFS.sh ;;
            3) $SELF_PATH/menu_Compress_PICS.sh ;;
            4) $SELF_PATH/menu_Virsh_Manager.sh ;;
            Q|q) clear && exit 0 ;;
            *) show_dialog_message msgbox "Invalid option $REPLY" ;;
        esac
    done
}

# If $1, run given function and skip main
case $1 in
    "mount_all")
        mount_all
        ;;
    "update_system")
        update_brew
        ;;
    "compress_pics")
        compress_pics
        ;;
    *)
        # Startup script
        dialog --msgbox "Welcome $HOME" 5 30
        MENU_PATH="Main Menu"
        main_menu
        ;;
esac