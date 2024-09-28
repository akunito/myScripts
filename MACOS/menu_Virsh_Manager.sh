#!/bin/bash

# Path to the functions file
SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/menu_functions.sh

MENU_PATH="Main Menu > Virsh Manager"

virsh_manager_menu() {
    local choice

    while true; do
        choice=$(dialog --clear --backtitle "$MENU_PATH" --title "Virsh Manager" \
                        --menu "Choose an option" 15 60 4 \
                        1 "Start default network" \
                        2 "Start nm-bridge network" \
                        Q "Quit" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1)
                dialog --infobox "Starting default network..." 3 40
                virsh net-start default
                dialog --msgbox "Default network started" 5 40
                ;;
            2)
                dialog --infobox "Starting nm-bridge network..." 3 40
                virsh net-start nm-bridge
                sudo ip link add nm-bridge type bridge
                sudo ip address add dev nm-bridge 192.168.0.0/24
                sudo ip link set dev nm-bridge up
                dialog --msgbox "NM-Bridge network started" 5 40
                ;;
            Q|q) exit 0 ;;
            *) show_dialog_message msgbox "Invalid option $REPLY" ;;
        esac
    done
}

virsh_manager_menu