#!/bin/bash

# Path to the functions file
SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/menu_functions.sh

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
                        Q "Quit" \
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
            1) $SSHFS_SH "mount" "normal" "$network_USER" "$IP_NetLab_ETH" "$IP_NetLab_WIFI" "22" "$network_HOME_ORIGEN" "$network_HOME_DESTINATION" "$network_HOME_VOLNAME" ;;
            2) $SSHFS_SH "unmount" "normal" "$network_USER" "$IP_NetLab_ETH" "$IP_NetLab_WIFI" "22" "$network_HOME_ORIGEN" "$network_HOME_DESTINATION" "$network_HOME_VOLNAME" ;;
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
            1) $SSHFS_SH "mount" "backup" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_MACAKUBACKUP_ORIGEN" "$server_MACAKUBACKUP_DESTINATION" "$server_MACAKUBACKUP_VOLNAME" "$server_MACAKUBACKUP_ATTACH" ;;
            2) $SSHFS_SH "unmount" "backup" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_MACAKUBACKUP_ORIGEN" "$server_MACAKUBACKUP_DESTINATION" "$server_MACAKUBACKUP_VOLNAME" "$server_MACAKUBACKUP_ATTACH" ;;
            3) $SSHFS_SH "mount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_DATA_4TB_ORIGEN" "$server_DATA_4TB_DESTINATION" "$server_DATA_4TB_VOLNAME" ;;
            4) $SSHFS_SH "unmount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_DATA_4TB_ORIGEN" "$server_DATA_4TB_DESTINATION" "$server_DATA_4TB_VOLNAME" ;;
            5) $SSHFS_SH "mount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_HOME_ORIGEN" "$server_HOME_DESTINATION" "$server_HOME_VOLNAME" ;;
            6) $SSHFS_SH "unmount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_HOME_ORIGEN" "$server_HOME_DESTINATION" "$server_HOME_VOLNAME" ;;
            7) $SSHFS_SH "mount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_MACHINES_ORIGEN" "$server_MACHINES_DESTINATION" "$server_MACHINES_VOLNAME" ;;
            8) $SSHFS_SH "unmount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_MACHINES_ORIGEN" "$server_MACHINES_DESTINATION" "$server_MACHINES_VOLNAME" ;;
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
            1) $SSHFS_SH "mount" "normal" "$agalaptop_USER" "$IP_LaptopAga_WIFI" "$IP_LaptopAga_ETH" "22" "$agalaptop_HOME_ORIGEN" "$agalaptop_HOME_DESTINATION" "$agalaptop_HOME_VOLNAME" ;;
            2) $SSHFS_SH "unmount" "normal" "$agalaptop_USER" "$IP_LaptopAga_WIFI" "$IP_LaptopAga_ETH" "22" "$agalaptop_HOME_ORIGEN" "$agalaptop_HOME_DESTINATION" "$agalaptop_HOME_VOLNAME" ;;
            Q|q) MENU_PATH="Main Menu > SSHFS" && return ;;
            *) show_dialog_message msgbox "Invalid option $REPLY" ;;
        esac
    done
}

sshfs_menu