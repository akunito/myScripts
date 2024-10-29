#!/bin/bash

# Path to the functions file
SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/menu_functions.sh

MENU_PATH="Main Menu > Update System"

update_system_menu() {
    local choice

    while true; do
        choice=$(dialog --clear --backtitle "$MENU_PATH" --title "Update System" \
                        --menu "Choose an option" 15 50 3 \
                        1 "ALL Up&Clean" \
                        2 "Update HomeLab" \
                        3 "Update AgaLaptop" \
                        Q "Quit/Back" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1) update_brew ;;
            2) update_nixos "$SSH_Server" "akunito" "HOME" "HomeLab" ;; # SSH Connection Variable | username | Flake Alias | Description
            3) update_nixos "$SSH_LaptopAga" "aga" "AGA" "AgaLaptop" ;;
            Q|q) exit 0 ;;
            *) show_dialog_message msgbox "Invalid option $REPLY" ;;
        esac
    done
}

update_system_menu