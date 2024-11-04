#!/bin/bash

# Path to the functions file
SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/menu_functions.sh
source $SELF_PATH/menu_Backups.sh

MENU_PATH="Main Menu > Update System"

perform_update() {
    local update_type="$1"
    
    case $update_type in
        "brew")
            update_brew
            ;;
        "homelab")
            update_nixos "$SSH_Server" "akunito" "HOME" "HomeLab"
            ;;
        "agalaptop")
            update_nixos "$SSH_LaptopAga" "aga" "AGA" "AgaLaptop"
            ;;
        "all")
            perform_update "brew"
            perform_update "homelab"
            perform_update "agalaptop"
            ;;
    esac
}

update_system_menu() {
    local choice

    while true; do
        choice=$(dialog --clear --backtitle "$MENU_PATH" --title "Update System" \
                        --menu "Choose an option" 15 50 4 \
                        1 "Update All Systems" \
                        2 "Update HomeBrew in this system" \
                        3 "Update HomeLab NixOS" \
                        4 "Update AgaLaptop NixOS" \
                        Q "Quit/Back" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1) 
                perform_update "all"
                wait_for_user_input
                ;;
            2) 
                perform_update "brew"
                wait_for_user_input
                ;;
            3) 
                perform_update "homelab"
                wait_for_user_input
                ;;
            4) 
                perform_update "agalaptop"
                wait_for_user_input
                ;;
            Q|q) exit 0 ;;
            *) show_dialog_message msgbox "Invalid option $REPLY" ;;
        esac
    done
}

update_system_menu