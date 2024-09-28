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

mount_all() {
    show_dialog_message infobox "Mounting all..." 5
    if $SSHFS_SH "mount" "normal" "$network_USER" "$IP_NetLab_ETH" "$IP_NetLab_WIFI" "22" "$network_HOME_ORIGEN" "$network_HOME_DESTINATION" "$network_HOME_VOLNAME" &&
       $SSHFS_SH "mount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_HOME_ORIGEN" "$server_HOME_DESTINATION" "$server_HOME_VOLNAME" &&
       $SSHFS_SH "mount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_DATA_4TB_ORIGEN" "$server_DATA_4TB_DESTINATION" "$server_DATA_4TB_VOLNAME" &&
       $SSHFS_SH "mount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_MACHINES_ORIGEN" "$server_MACHINES_DESTINATION" "$server_MACHINES_VOLNAME" &&
       $SSHFS_SH "mount" "normal" "$agalaptop_USER" "$IP_LaptopAga_WIFI" "$IP_LaptopAga_ETH" "22" "$agalaptop_HOME_ORIGEN" "$agalaptop_HOME_DESTINATION" "$agalaptop_HOME_VOLNAME"; then
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
