#!/bin/bash
# Bash Menu Script Example

SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
echo $SELF_PATH
# Include VARIABLES.sh
source $SELF_PATH/VARIABLES.sh
# Include NETWORK.sh
source $SELF_PATH/../NETWORK.sh

main() {
    # Main menu
    clear
    echo "SELF_PATH: $SELF_PATH"
    PS3='Please enter your choice: '
    options=("Quit" "Update System" "sshfs" "compress PICS" "virsh manager")
    select opt in "${options[@]}"; do
        case $opt in
            "Quit")
                clear
                break
                ;;

            "Update System")
                update_system
                ;;

            "sshfs")
                manage_sshfs
                ;;

            "compress PICS")
                compress_pics
                ;;

            "virsh manager")
                manage_virsh
                ;;

            *)
                echo "Invalid option $REPLY"
                ;;
        esac
    done
}

update_system() {
    clear
    PS3='Please enter your choice: '
    options=("Quit" "ALL Up&Clean")
    select opt in "${options[@]}"; do
        case $opt in
            "ALL Up&Clean")
                clear
                brew upgrade
                brew cleanup
                ;;

            "Quit")
                clear
                break
                ;;

            *)
                echo "Invalid option $REPLY"
                ;;
        esac
    done
}

manage_sshfs() {
    clear
    PS3='Please enter your choice: '
    options=("Quit" "MOUNT ALL" "mynet" "myserver" "agalaptop")
    select opt in "${options[@]}"; do
        case $opt in
            "MOUNT ALL")
                mount_all
                ;;

            "mynet")
                manage_mynet
                ;;

            "myserver")
                manage_myserver
                ;;

            "agalaptop")
                manage_agalaptop
                ;;

            "Quit")
                clear
                break
                ;;

            *)
                echo "Invalid option $REPLY"
                ;;
        esac
    done
}

mount_all() {
    clear
    echo "\n=========================================== myNet"
    echo "==== mount home"
    $SELF_PATH/sshfs/SSHFS.sh "mount" "normal" "$network_USER" "$IP_NetLab_ETH" "$IP_NetLab_WIFI" "22" "$network_HOME_ORIGEN" "$network_HOME_DESTINATION" "$network_HOME_VOLNAME"

    echo "\n=========================================== myServer"
    echo "==== mount home"
    $SELF_PATH/sshfs/SSHFS.sh "mount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_HOME_ORIGEN" "$server_HOME_DESTINATION" "$server_HOME_VOLNAME"
    echo "==== mount DATA_4TB"
    $SELF_PATH/sshfs/SSHFS.sh "mount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_DATA_4TB_ORIGEN" "$server_DATA_4TB_DESTINATION" "$server_DATA_4TB_VOLNAME"
    echo "==== mount Machines"
    $SELF_PATH/sshfs/SSHFS.sh "mount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_MACHINES_ORIGEN" "$server_MACHINES_DESTINATION" "$server_MACHINES_VOLNAME"

    echo "\n=========================================== agaLaptop"
    echo "==== mount home"
    $SELF_PATH/sshfs/SSHFS.sh "mount" "normal" "$agalaptop_USER" "$IP_LaptopAga_WIFI" "$IP_LaptopAga_ETH" "22" "$agalaptop_HOME_ORIGEN" "$agalaptop_HOME_DESTINATION" "$agalaptop_HOME_VOLNAME"
}

manage_mynet() {
    clear
    PS3='Please enter your choice: '
    options=("Quit" "mount mynet_HOME" "unmount mynet_HOME")
    select opt in "${options[@]}"; do
        case $opt in
            "mount mynet_HOME")
                clear
                $SELF_PATH/sshfs/SSHFS.sh "mount" "normal" "$network_USER" "$IP_NetLab_ETH" "$IP_NetLab_WIFI" "22" "$network_HOME_ORIGEN" "$network_HOME_DESTINATION" "$network_HOME_VOLNAME"
                ;;

            "unmount mynet_HOME")
                clear
                $SELF_PATH/sshfs/SSHFS.sh "unmount" "normal" "$network_USER" "$IP_NetLab_ETH" "$IP_NetLab_WIFI" "22" "$network_HOME_ORIGEN" "$network_HOME_DESTINATION" "$network_HOME_VOLNAME"
                ;;

            "Quit")
                clear
                break
                ;;

            *)
                echo "Invalid option $REPLY"
                ;;
        esac
    done
}

manage_myserver() {
    clear
    PS3='Please enter your choice: '
    options=("Quit" "mount MacBookPro_BACKUPS" "unmount MacBookPro_BACKUPS" "mount Data_4TB" "unmount Data_4TB" "mount server home" "unmount server home" "mount server Machines" "unmount server Machines")
    select opt in "${options[@]}"; do
        case $opt in
            "mount MacBookPro_BACKUPS")
                clear
                $SELF_PATH/sshfs/SSHFS.sh "mount" "backup" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_MACAKUBACKUP_ORIGEN" "$server_MACAKUBACKUP_DESTINATION" "$server_MACAKUBACKUP_VOLNAME" "$server_MACAKUBACKUP_ATTACH"
                ;;

            "unmount MacBookPro_BACKUPS")
                clear
                $SELF_PATH/sshfs/SSHFS.sh "unmount" "backup" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_MACAKUBACKUP_ORIGEN" "$server_MACAKUBACKUP_DESTINATION" "$server_MACAKUBACKUP_VOLNAME" "$server_MACAKUBACKUP_ATTACH"
                ;;

            "mount Data_4TB")
                clear
                $SELF_PATH/sshfs/SSHFS.sh "mount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_DATA_4TB_ORIGEN" "$server_DATA_4TB_DESTINATION" "$server_DATA_4TB_VOLNAME"
                ;;

            "unmount Data_4TB")
                clear
                $SELF_PATH/sshfs/SSHFS.sh "unmount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_DATA_4TB_ORIGEN" "$server_DATA_4TB_DESTINATION" "$server_DATA_4TB_VOLNAME"
                ;;

            "mount server home")
                clear
                $SELF_PATH/sshfs/SSHFS.sh "mount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_HOME_ORIGEN" "$server_HOME_DESTINATION" "$server_HOME_VOLNAME"
                ;;

            "unmount server home")
                clear
                $SELF_PATH/sshfs/SSHFS.sh "unmount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_HOME_ORIGEN" "$server_HOME_DESTINATION" "$server_HOME_VOLNAME"
                ;;

            "mount server Machines")
                clear
                $SELF_PATH/sshfs/SSHFS.sh "mount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_MACHINES_ORIGEN" "$server_MACHINES_DESTINATION" "$server_MACHINES_VOLNAME"
                ;;

            "unmount server Machines")
                clear
                $SELF_PATH/sshfs/SSHFS.sh "unmount" "normal" "$server_USER" "$IP_Server_ETH" "$IP_Server_WIFI" "22" "$server_MACHINES_ORIGEN" "$server_MACHINES_DESTINATION" "$server_MACHINES_VOLNAME"
                ;;

            "Quit")
                clear
                break
                ;;

            *)
                echo "Invalid option $REPLY"
                ;;
        esac
    done
}

manage_agalaptop() {
    clear
    PS3='Please enter your choice: '
    options=("Quit" "mount agalaptop_HOME" "unmount agalaptop_HOME")
    select opt in "${options[@]}"; do
        case $opt in
            "mount agalaptop_HOME")
                clear
                $SELF_PATH/sshfs/SSHFS.sh "mount" "normal" "$agalaptop_USER" "$IP_LaptopAga_WIFI" "$IP_LaptopAga_ETH" "22" "$agalaptop_HOME_ORIGEN" "$agalaptop_HOME_DESTINATION" "$agalaptop_HOME_VOLNAME"
                ;;

            "unmount agalaptop_HOME")
                clear
                $SELF_PATH/sshfs/SSHFS.sh "unmount" "normal" "$agalaptop_USER" "$IP_LaptopAga_WIFI" "$IP_LaptopAga_ETH" "22" "$agalaptop_HOME_ORIGEN" "$agalaptop_HOME_DESTINATION" "$agalaptop_HOME_VOLNAME"
                ;;

            "Quit")
                clear
                break
                ;;

            *)
                echo "Invalid option $REPLY"
                ;;
        esac
    done
}

compress_pics() {
    clear
    PS3='Please enter your choice: '
    options=("Quit" "Obsidian/*.PNG")
    select opt in "${options[@]}"; do
        case $opt in
            "Obsidian/*.PNG")
                clear
                $SELF_PATH/functions/compressPNGobsidian.sh $ObsidianNotesPATH
                ;;

            "Quit")
                clear
                break
                ;;

            *)
                echo "Invalid option $REPLY"
                ;;
        esac
    done
}

manage_virsh() {
    clear
    PS3='Please enter your choice: '
    options=("Quit" "Start default network" "Start nm-bridge network")
    select opt in "${options[@]}"; do
        case $opt in
            "Start default network")
                clear
                virsh net-start default
                ;;

            "Start nm-bridge network")
                clear
                virsh net-start nm-bridge
                sudo ip link add nm-bridge type bridge
                sudo ip address add dev nm-bridge 192.168.0.0/24
                sudo ip link set dev nm-bridge up
                ;;

            "Quit")
                clear
                break
                ;;

            *)
                echo "Invalid option $REPLY"
                ;;
        esac
    done
}

# Startup script
echo "Welcome $HOME"
main
