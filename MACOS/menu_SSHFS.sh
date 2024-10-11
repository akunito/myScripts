#!/bin/bash

# Path to the functions file
SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/menu_functions.sh
source $NETWORK_PATH

MENU_PATH="Main Menu > SSHFS"

sshfs_menu() {
    local choice

    while true; do
        choice=$(dialog --clear --backtitle "$MENU_PATH" --title "Manage SSHFS" \
                        --menu "Choose an option" 15 50 6 \
                        1 "MOUNT ALL" \
                        2 "mynet" \
                        3 "myserver" \
                        4 "agalaptop" \
                        Q "Quit/Back" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1) mount_all ;;
            2) mynet_menu ;;
            3) myserver_menu ;;
            4) agalaptop_menu ;;
            Q|q) exit 0 ;;
            *) show_dialog_message msgbox "Invalid option $REPLY" ;;
        esac
    done
}

mynet_menu() {
    local choice

    MENU_PATH="Main Menu > SSHFS > MyNet"
    while true; do
        choice=$(dialog --clear --backtitle "$MENU_PATH" --title "Manage MyNet" \
                        --menu "Choose an option" 15 50 4 \
                        1 "mount mynet_HOME" \
                        2 "unmount mynet_HOME" \
                        Q "Quit" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1) eval $network_HOME_MOUNT ;;
            2) eval $network_HOME_UNMOUNT ;;
            Q|q) MENU_PATH="Main Menu > SSHFS" && return ;;
            *) show_dialog_message msgbox "Invalid option $REPLY" ;;
        esac
    done
}

myserver_menu() {
    local choice

    MENU_PATH="Main Menu > SSHFS > MyServer"
    while true; do
        choice=$(dialog --clear --backtitle "$MENU_PATH" --title "Manage MyServer" \
                        --menu "Choose an option" 15 60 10 \
                        1 "mount MacBookPro_BACKUPS" \
                        2 "unmount MacBookPro_BACKUPS" \
                        3 "mount Data_4TB" \
                        4 "unmount Data_4TB" \
                        5 "mount server home" \
                        6 "unmount server home" \
                        7 "mount server Machines" \
                        8 "unmount server Machines" \
                        Q "Quit" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1) eval $server_MACAKUBACKUP_MOUNT ;;
            2) eval $server_MACAKUBACKUP_UNMOUNT ;;
            3) eval $server_DATA_4TB_MOUNT ;;
            4) eval $server_DATA_4TB_UNMOUNT ;;
            5) eval $server_HOME_MOUNT ;;
            6) eval $server_HOME_UNMOUNT ;;
            7) eval $server_MACHINES_MOUNT ;;
            8) eval $server_MACHINES_UNMOUNT ;;
            Q|q) MENU_PATH="Main Menu > SSHFS" && return ;;
            *) show_dialog_message msgbox "Invalid option $REPLY" ;;
        esac
    done
}

agalaptop_menu() {
    local choice

    MENU_PATH="Main Menu > SSHFS > AgaLaptop"
    while true; do
        choice=$(dialog --clear --backtitle "$MENU_PATH" --title "Manage AgaLaptop" \
                        --menu "Choose an option" 15 50 4 \
                        1 "mount agalaptop_HOME" \
                        2 "unmount agalaptop_HOME" \
                        Q "Quit" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1) eval $agalaptop_HOME_MOUNT ;;
            2) eval $agalaptop_HOME_UNMOUNT ;;
            Q|q) MENU_PATH="Main Menu > SSHFS" && return ;;
            *) show_dialog_message msgbox "Invalid option $REPLY" ;;
        esac
    done
}

sshfs_menu