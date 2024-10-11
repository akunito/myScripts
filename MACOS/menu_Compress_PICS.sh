#!/bin/bash

# Path to the functions file
SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/menu_functions.sh

MENU_PATH="Main Menu > Compress PICS"

compress_pics_menu() {
    local choice

    while true; do
        choice=$(dialog --clear --backtitle "$MENU_PATH" --title "Compress PICS" \
                        --menu "Choose an option" 15 50 3 \
                        1 "Obsidian/*.PNG" \
                        Q "Quit/Back" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1) compress_pics ;;
            Q|q) exit 0 ;;
            *) show_dialog_message msgbox "Invalid option $REPLY" ;;
        esac
    done
}

compress_pics_menu