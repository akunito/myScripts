#!/bin/bash

# Path to the functions file
SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/menu_functions.sh

MENU_PATH="Main Menu > Update Project Docs"

update_docs() {
    local update_type="$1"
    
    case $update_type in
        "NixOS_dotfiles")
            sync_docs_to_ssh_project "/Users/akunito/syncthing/git_repos/myProjects/nixos_dotfiles" "$server_USER" "$IP_Server_ETH" "/home/akunito/.dotfiles"
            ;;
        "Homelab_services")
            sync_docs_to_ssh_project "/Users/akunito/syncthing/git_repos/myProjects/my_homelab" "$server_USER" "$IP_Server_ETH" "/home/akunito/.homelab"
            ;;
        "all")
            update_docs "NixOS_dotfiles"
            update_docs "Homelab_services"
            ;;
    esac
}

update_project_docs_menu() {
    local choice

    while true; do
        choice=$(dialog --clear --backtitle "$MENU_PATH" --title "Update System" \
                        --menu "Choose an option" 15 50 4 \
                        1 "Update All" \
                        2 "Update NixOS_dotfiles" \
                        3 "Update Homelab_services" \
                        Q "Quit/Back" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1) 
                update_docs "all"
                wait_for_user_input
                ;;
            2) 
                update_docs "NixOS_dotfiles"
                wait_for_user_input
                ;;
            3) 
                update_docs "Homelab_services"
                wait_for_user_input
                ;;
            Q|q) exit 0 ;;
            *) show_dialog_message msgbox "Invalid option $REPLY" ;;
        esac
    done
}

update_project_docs_menu