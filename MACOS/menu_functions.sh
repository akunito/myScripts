#!/bin/bash
# menu_functions.sh

# Ensure dialog is installed
if ! command -v dialog &>/dev/null; then
    echo "The 'dialog' utility is not installed. Please install it and run this script again."
    exit 1
fi

# Color variables (optional, for potential future use)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")

# Include VARIABLES.sh
source $SELF_PATH/VARIABLES.sh
# Include NETWORK.sh
source $SELF_PATH/../NETWORK.sh

show_dialog_message() {
    local type="$1"
    local message="$2"
    local duration="${3:-3}"
    case $type in
        infobox)
            dialog --infobox "$message" "$duration" 40
            ;;
        msgbox)
            dialog --msgbox "$message" 5 40
            ;;
    esac
}

update_brew() {
    show_dialog_message infobox "Updating Homebrew..." 5
    if brew upgrade && brew cleanup; then
        show_dialog_message msgbox "Homebrew updated and cleaned"
    else
        show_dialog_message msgbox "Error updating Homebrew"
    fi
}

ssh_interactive_command() {
    local ssh_connection="${1}"
    local command="$2"

    # Concatenate `ssh_connection` with `-t` and the command
    local ssh_message="${ssh_connection} -t '${command}'

    echo -e \"\n\033[1;32mTask completed!\033[0m\";
    echo -e \"\033[1;33mThe SSH session will close in 10 seconds. Press any key to leave now...\033[0m\";

    if ! read -t 10 -n 1; then
        exit
    fi
    exec \$SHELL -l
    '"

    # Execute the SSH command
    eval "${ssh_message}"
}
update_nixos() {
    # echo "ssh_connection = $1"
    # echo "username = $2"
    # echo "flake_alias = $3"
    # echo "description = $4"
    local ssh_connection="$1"
    local username="$2"
    local flake_alias="$3"
    local description="$4"

    echo "Updating the $description system..."

    ssh_interactive_command "$ssh_connection" "sh /home/$username/.dotfiles/install.sh /home/$username/.dotfiles $flake_alias -s"
    
    # wait key from user to leave the dialog
    read -n 1 -s -r -p "Press any key to continue..."
}

mount_all() {
    show_dialog_message infobox "Mounting all..." 5
    if $network_HOME_MOUNT &&
       $server_HOME_MOUNT &&
       $server_DATA_4TB_MOUNT &&
       $server_MACHINES_MOUNT &&
       $agalaptop_HOME_MOUNT
       ; then
        show_dialog_message msgbox "Mounting complete"
    else
        show_dialog_message msgbox "Error mounting"
    fi
}

compress_pics() {
    show_dialog_message infobox "Compressing pictures..." 5
    if $SELF_PATH/functions/compressPNGobsidian.sh $OBSIDIANNOTES_PATH; then
        show_dialog_message msgbox "Compression complete"
    else
        show_dialog_message msgbox "Error compressing pictures"
    fi
}

