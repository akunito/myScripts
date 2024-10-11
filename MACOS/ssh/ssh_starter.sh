#!/bin/bash

# Include necessary sources
source $VARIABLES_PATH
source $NETWORK_PATH

# ============================== Associated ARRAYs for each SERVER ======================
VPN_COMMANDS=("${VPN_SERVER[SSH][@]}")

LAPTOP_AGA_COMMANDS=(
    "${LAPTOP_AGA_SERVER[SSH][@]}"
    "${LAPTOP_AGA_SERVER[DRIVES][@]}"
    "${LAPTOP_AGA_SERVER[PROJECTS][@]}"
)

HOMELAB_COMMANDS=(
    "${HOMELAB_SERVER[SSH][@]}"
    "${HOMELAB_SERVER[DRIVES][@]}"
    "${HOMELAB_SERVER[PROJECTS][@]}"
)

LAB_SERVER_COMMANDS=(
    "${LAB_SERVER[SSH][@]}"
    "${LAB_SERVER[DRIVES][@]}"
    "${LAB_SERVER[PROJECTS][@]}"
)

function list_commands {
    local server_commands=("$@")
    for command in "${server_commands[@]}"; do
        echo "$command"
    done
}


# ============================== Functions ==============================================
# Using the function
list_commands "${VPN_COMMANDS[@]}"
list_commands "${HOMELAB_COMMANDS[@]}"

function timeout() { perl -e 'alarm shift; exec @ARGV' "$@"; }

function connect_ssh_with_fallback {
    local ssh_command1=$1
    local ssh_command2=${2:-$1}  # Use the first command again if the second is not provided

    for ssh_command in "$ssh_command1" "$ssh_command2"; do
        echo "Attempting to connect using: $ssh_command"
        
        # Attempt to connect by SSH
        $ssh_command
        if [ $? -eq 0 ]; then
            echo "Connected successfully."
            return 0
        else
            echo "SSH attempt failed, trying next command if applicable..."
        fi
    done

    echo "Failed to connect with both SSH commands."
    return 1
}

function show_menu {
    # Display list of available servers
    echo "Choose a server:"
    echo "1) Server VPN"
    echo "2) Laptop Aga"
    echo "3) Server Homelab"
    echo "4) Server Lab"
    read -p "Enter choice [1-4]: " server_choice

    case $server_choice in
        1) server="VPN"; server_ip=$IP_VPN;;
        2) server="LaptopAga"; server_ip=$IP_LaptopAga_ETH;;
        3) server="Homelab"; server_ip=$IP_Server_ETH;;
        4) server="Lab"; server_ip=$IP_NetLab_ETH;;
        *) echo "Invalid option"; exit 1;;
    esac
}

function show_actions {
    # Placeholder for displaying actions based on selected server
    echo "Select actions to perform:"
    # Example checkbox options using dialog or whiptail can be added here
}

# Main execution flow
if [ "$#" -eq 0 ]; then
    show_menu
    show_actions
    read -p "Do you want to connect via SSH to the server? (yes/no): " connect
    if [ "$connect" == "yes" ]; then
        connect_ssh_with_fallback "$SSH_command" "$SSH_command_2" # TODO GET COMMAND FROM USER ?
    fi
else
    server=$1
    default_conn=$2
    # Direct connection logic or further parameter handling can be implemented here
    case $1 in
        "ssh")
            echo "should receive 2 ssh command strings, for example > 'ssh -p 22 $server_USER@$IP_Server_ETH'"
            echo "or pass the variables from NETWORK.sh like > '$SSH_Server'"
            connect_ssh_with_fallback "$2" "$3"
            ;;
        "update_system")
            update_brew
            ;;
        *)
            # Startup script
            echo "parameter 1 does not match any known options"
            exit 1
            ;;
    esac
fi
