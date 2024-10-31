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

wait_for_user_input() {
    read -n 1 -s -r -p "Press any key to continue..."
}

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

    # The -A flag enables SSH agent forwarding, which allows the remote server to use your local SSH keys for authentication. 
    # This should resolve the "Host key verification failed" error when trying to clone Git repositories over SSH from the remote server.
    # Make sure that:
    # - Your SSH agent is running locally (ssh-agent)
    # - Your SSH key is added to the agent (ssh-add)
    # - The SSH config on your local machine allows agent forwarding for the remote host
    # You can also add this to your ~/.ssh/config file for the specific host like:
    #   Host your-remote-host
    #       ForwardAgent yes

    local ssh_message="${ssh_connection} -A -t '${command}'

    echo -e \"\n\033[1;32mTask completed!\033[0m\";
    exec \$SHELL -l
    '"

    # Execute the SSH command
    eval "${ssh_message}"
}

get_system_password() {
    local system_name="$1"
    local keychain_name="NixOS_Systems"
    
    # Try to get password from keychain
    password=$(security find-generic-password -a "$system_name" -s "$keychain_name" -w 2>/dev/null)
    
    # If password doesn't exist, prompt user to add it
    if [ -z "$password" ]; then
        password=$(dialog --clear --insecure --passwordbox "Enter sudo password for $system_name:" 8 50 3>&1 1>&2 2>&3)
        if [ $? -eq 0 ]; then
            # Store password in keychain
            security add-generic-password -a "$system_name" -s "$keychain_name" -w "$password"
        else
            return 1
        fi
    fi
    echo "$password"
}

update_nixos() {
    local ssh_connection="$1"
    local username="$2"
    local flake_alias="$3"
    local description="$4"

    echo "Updating the $description system..."
    
    # Get password from keychain
    local password=$(get_system_password "$description")
    if [ $? -ne 0 ]; then
        show_dialog_message msgbox "Password operation cancelled"
        return 1
    fi
    # TEST
    echo "$password" | ssh_interactive_command "$ssh_connection" "ssh-add -l && ssh -vT git@github.com"
    
    # Use password in the SSH command
    echo "$password" | ssh_interactive_command "$ssh_connection" "/home/$username/.dotfiles/install.sh /home/$username/.dotfiles $flake_alias"
}
# TEST
update_nixos "$SSH_Server" "akunito" "HOME" "HomeLab"

mount_all() {
    show_dialog_message infobox "Mounting all..." 5
    if $network_HOME_MOUNT &&
       $server_HOME_MOUNT &&
       $server_DATA_4TB_MOUNT &&
       $server_MACHINES_MOUNT &&
       $agalaptop_HOME_MOUNT; then
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

