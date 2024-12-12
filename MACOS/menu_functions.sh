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
source $VARIABLES_PATH
# Include NETWORK.sh
source $NETWORK_PATH

wait_for_user_input() {
    echo ""
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

# Given a file path, create the file and the directory if it doesn't exist
create_file() {
    local file_path="$1"
    local directory=$(dirname "$file_path")
    mkdir -p "$directory"
    touch "$file_path"
}

sync_directory_to_backup_efficiently() {
    # Usage: sync_directory_to_backup_efficiently "/home/akunito/" "/mnt/DATA_4TB/backups/NixOS_homelab_home/" "EXCLUDEcontentOfDIR1/** EXCLUDEfullDIR2"
    local source_path="$1"
    local destination_path="$2"
    local base_paths_to_exclude=".com.apple.backupd* *.sock */dev/* .DS_Store */.DS_Store .tldrc/ \
    .cache/ .Cache/ cache/ Cache/ */.cache/ */.Cache/ */cache/ */Cache/ \
    .trash/ .Trash/ trash/ Trash/ */.trash/ */.Trash/ */trash/ */Trash/ "
    # Concat $base_paths_to_exclude with $3
    local exclude_paths="$base_paths_to_exclude $3"

    # Print the colored message to stderr so it doesn't affect the return value
    echo -e "${YELLOW}Generating command to sync from $source_path to $destination_path...${NC}" >&2
    
    local cmd="rsync -avpP --delete --delete-excluded"
    # local cmd="rclone sync --links -P"
    
    # If exclude_paths is not empty, add each exclude path
    if [ -n "$exclude_paths" ]; then
        # Split exclude_paths on spaces and add each as --exclude
        for path in $exclude_paths; do
            cmd="$cmd --exclude \"$path\""
        done
    fi
    
    # Add source and destination paths
    cmd="$cmd \"$source_path\" \"$destination_path\""
    
    printf "%s" "$cmd"
}

sync_directory_to_backup_efficiently_ssh() {
    # Usage: sync_directory_to_backup_efficiently "/home/akunito/" "/mnt/DATA_4TB/backups/NixOS_homelab_home/" "EXCLUDEcontentOfDIR1/** EXCLUDEfullDIR2"
    local source_path="$1"
    local destination_path="$2"
    local base_paths_to_exclude=".com.apple.backupd* *.sock */dev/* .DS_Store */.DS_Store .tldrc/ \
    .cache/ .Cache/ cache/ Cache/ */.cache/ */.Cache/ */cache/ */Cache/ \
    .trash/ .Trash/ trash/ Trash/ */.trash/ */.Trash/ */trash/ */Trash/ "
    # Concat $base_paths_to_exclude with $3
    local exclude_paths="$base_paths_to_exclude $3"

    # Print the colored message to stderr so it doesn't affect the return value
    echo -e "${YELLOW}Generating command to sync from $source_path to $destination_path...${NC}" >&2
    
    local cmd="rsync -avpP --delete --delete-excluded \"ssh -p 22\""
    # local cmd="rclone sync --links -P"
    
    # If exclude_paths is not empty, add each exclude path
    if [ -n "$exclude_paths" ]; then
        # Split exclude_paths on spaces and add each as --exclude
        for path in $exclude_paths; do
            cmd="$cmd --exclude \"$path\""
        done
    fi
    
    # Add source and destination paths
    cmd="$cmd \"$source_path\" \"$destination_path\""
    
    printf "%s" "$cmd"
}

sync_directory_to_backup_efficiently_rclone() {
    # rclone version uses rclone instead. This is better for copying from MacOS to Linux keeping permissions.

    # Usage: sync_directory_to_backup_efficiently_rclone "/home/akunito/" "/mnt/DATA_4TB/backups/NixOS_homelab_home/" "EXCLUDEcontentOfDIR1/** EXCLUDEfullDIR2"
    local source_path="$1"
    local destination_path="$2"
    local base_paths_to_exclude=".com.apple.backupd* *.sock */dev/* .DS_Store */.DS_Store .tldrc/ \
    .cache/ .Cache/ cache/ Cache/ */.cache/ */.Cache/ */cache/ */Cache/ \
    .trash/ .Trash/ trash/ Trash/ */.trash/ */.Trash/ */trash/ */Trash/ "
    # Concat $base_paths_to_exclude with $3
    local exclude_paths="$base_paths_to_exclude $3"

    # Print the colored message to stderr so it doesn't affect the return value
    echo -e "${YELLOW}Generating command to sync from $source_path to $destination_path...${NC}" >&2
    
    local cmd="rclone sync --links -P --stats=1s"
    # local cmd="rclone sync --links -P"
    
    # If exclude_paths is not empty, add each exclude path
    if [ -n "$exclude_paths" ]; then
        # Split exclude_paths on spaces and add each as --exclude
        for path in $exclude_paths; do
            cmd="$cmd --exclude \"$path\""
        done
    fi
    
    # Add source and destination paths
    cmd="$cmd \"$source_path\" \"$destination_path\""
    
    printf "%s" "$cmd"
}

# Function to check if log file exceeds 1MB and rotate it
rotate_log() {
    local log_file="$1"
    local MAX_log_fileS="3"
    max_size=$((1 * 1024 * 1024)) # 1MB in bytes
    create_file "$log_file"
    
    # Detect OS and use appropriate stat command
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        file_size=$(stat -f%z "$log_file")
    else
        # Linux and others
        file_size=$(stat -c%s "$log_file")
    fi

    if [ "$file_size" -gt "$max_size" ]; then
        # Rotate the current log file
        mv "$log_file" "${log_file}_$(date '+%Y-%m-%d_%H-%M-%S').old"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Log file rotated. A new log file has been created." >> "$log_file"
        
        # Manage old log files: keep only the last $MAX_log_fileS files
        log_count=$(ls -1 "${log_file}_*.old" 2>/dev/null | wc -l)
        if [ "$log_count" -gt "$MAX_log_fileS" ]; then
            # Delete the oldest log files, keep only $MAX_log_fileS most recent
            ls -1t "${log_file}_*.old" | tail -n +$((MAX_log_fileS + 1)) | xargs rm -f
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Old log files cleaned up. Kept only the last $MAX_log_fileS files." >> "$log_file"
        fi
    fi
}

# Log function: logs datetime, task, and output
log_task() {
    local log_file="$1"
    local task="$2"
    local command="$3"
    local output
    create_file "$log_file"

    # echo "[$(date '+%Y-%m-%d %H:%M:%S')] | $task | " | tee -a "$log_file"

    # Run the command and capture its output while showing it
    eval "$command" 2>&1 | while IFS= read -r line; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] | $task | $line" | tee -a "$log_file"
    done

    # Store the exit status (due to pipe, need to use ${PIPESTATUS[0]})
    local status=${PIPESTATUS[0]}
    
    if [ $status -eq 0 ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] | $task | Task completed successfully." | tee -a "$log_file"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] | $task | ================================" | tee -a "$log_file"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] | $task | ERROR: the task failed." | tee -a "$log_file"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] | $task | ================================" | tee -a "$log_file"
    fi
}

update_brew() {
    local log_file="$HOME/.logs/update_brew.log"
    
    # Rotate log if needed
    rotate_log "$log_file"
    
    # Start log
    log_task "$log_file" "Starting " "echo \"Homebrew maintenance started on $(date)\""
    
    # Update Homebrew itself
    log_task "$log_file" "Updating " "brew update"
    
    # Upgrade all packages
    log_task "$log_file" "Upgrading" "brew upgrade"
    
    # Cleanup old versions
    log_task "$log_file" "Cleaning " "brew cleanup"
    
    # End log
    log_task "$log_file" "Completed" "echo \"Homebrew maintenance completed on $(date)\""
}

get_system_password() {
    # Show help text if requested
    for arg in "$@"; do
        if [[ "$arg" == "-h" ]] || [[ "$arg" == "--help" ]]; then
            cat << EOF
Usage: get_system_password <system_name>

Arguments:
    system_name    Name of the system to retrieve/store password for

Description:
    Retrieves system password from keychain or prompts to create if not found.
    Uses keychain name "SSH_Systems" for storage.

Example:
    get_system_password "mysystem"
EOF
            return 0
        fi
    done

    local system_name="$1"
    local keychain_name="SSH_Systems"
    
    # Notify by console and MacOS notifications about the attempt
    # Check if the system is macOS
    if [[ "$(uname)" == "Darwin" ]]; then
        osascript -e 'display notification "Trying to get password from keychain..." with title '$system_name''
    else
        # Space for other systems to be scripted
        echo -e "\nFor no Mac systems: If you need notifications, implement them here."
    fi
    echo -e "${YELLOW}Trying to get password from keychain...${NC}"
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

ssh_interactive_command() {
    local ssh_connection="${1}"
    local command="$2"
    local enable_log="$3"
    
    # if: enable_log is "false", 
    # then: dont generate logs
    # else: generate logs and rotate the log file, executing the script in the remote machine
    if [ "$enable_log" == "false" ]; then
        additional_command=""
        echo -e "${YELLOW}logs disabled${NC}"
    else
        additional_command="| tee -a \"maintenance.log\""
        rotate_log="${ssh_connection} -t 'sh ~/myScripts/rotateLogFile.sh; echo \"log file has been rotated\"; exit'"
        eval "${rotate_log}"
    fi

    local ssh_message="${ssh_connection} -t '
    touch \"maintenance.log\";

    ${command} ${additional_command};

    echo -e \"\n\033[1;32mTask completed!\033[0m\";
    echo -e \"\033[1;33mThe SSH session will close in 8 seconds. Press ENTER to stay connected...\033[0m\";
    if ! read -t 8 -n 1; then
        exit
    fi
    exec \$SHELL -l
    '"

    eval "${ssh_message}"
}

update_nixos() {
    local ssh_connection="$1"
    local username="$2"
    local flake_alias="$3"
    local system_name="$4" # System name that will be used to get the password from the keychain

    # Get password from keychain
    local password=$(get_system_password "$system_name")
    if [ $? -ne 0 ]; then
        show_dialog_message msgbox "Password operation cancelled"
        return 1
    fi
    
    echo -e "${GREEN}Updating the $system_name system...${NC}"
    ssh_interactive_command "$ssh_connection" "sh \"/home/$username/.dotfiles/install.sh\" \"/home/$username/.dotfiles\" \"$flake_alias\" \"$password\" -s"
}

ssh_command() {
    # Show help text if requested
    for arg in "$@"; do
        if [[ "$arg" == "-h" ]] || [[ "$arg" == "--help" ]]; then
            cat << EOF
Usage: ssh_command <ssh_connection> <system_name> <command>

Arguments:
    ssh_connection   SSH connection string (e.g., "ssh username@serverIP")
    system_name      Name of the system (used for password retrieval)
    command          Command to execute (use 'sudo' if root access needed)
    --no-log         Disable logging

Example:
    ssh_command "ssh username@serverIP" "mysystem" "sudo apt update"
EOF
            return 0
        fi
    done

    local ssh_connection="$1"
    local system_name="$2"
    local command="$3"

    # if --no-log is received as parameter, make enable_log false, otherwise empty it
    for arg in "$@"; do
        if [[ "$arg" == "--no-log" ]]; then
            enable_log="false"
        fi
    done

    # Set $SUDO true if $command contains sudo
    local SUDO=false
    if [[ "$command" == *"sudo"* ]]; then
        SUDO=true
    fi
    # Get password from keychain if $SUDO is true
    if $SUDO; then
        local password=$(get_system_password "$system_name")
        if [ $? -ne 0 ]; then
        show_dialog_message msgbox "Password operation cancelled"
            return 1
        fi
    fi
    # Use $password in sudo command
    SUDO_CMD="echo \"${password}\" | sudo -S \"\$@\""
    # Replace sudo with $SUDO_CMD in $command
    command=$(echo "$command" | sed "s/sudo/$SUDO_CMD/g")

    echo -e "\nUpdating the $system_name system..."
    ssh_interactive_command "$ssh_connection" "$command" "$enable_log"
}

mount_all() {
    show_dialog_message infobox "Mounting all..." 5
    if #$network_HOME_MOUNT &&
       $server_HOME_MOUNT &&
       $server_DATA_4TB_MOUNT &&
       $server_MACAKUBACKUP_MOUNT &&
       #$server_MACHINES_MOUNT &&
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
