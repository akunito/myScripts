#!/bin/bash

# =======================================================================================
# ============================== IP addresses ===========================================
# ================== Server VPN
VPN_USER="root"
IP_VPN_INT="172.26.3.155"
IP_VPN_EXT="51.38.145.44"
SSH_VPN_INT="ssh -p 56777 $VPN_USER@$IP_VPN_INT"
SSH_VPN_EXT="ssh -p 56777 $VPN_USER@$IP_VPN_EXT"
# ================== My Router Flint
router_USER="root"
IP_RouterLAN="192.168.8.1"
IP_RouterWG="172.26.5.1"
SSH_RouterLAN="ssh -p 22 $router_USER@$IP_RouterLAN"
SSH_RouterWG="ssh -p 22 $router_USER@$IP_RouterWG"
# ================== Laptop Aga
agalaptop_USER="aga"
IP_LaptopAga_ETH="192.168.8.77"
IP_LaptopAga_WIFI="192.168.8.78"
SSH_LaptopAga="ssh -p 22 -A $agalaptop_USER@$IP_LaptopAga_WIFI"
SSH_LaptopAga_2="ssh -p 22 -A $agalaptop_USER@$IP_LaptopAga_ETH"
# ================== Server Homelab
server_USER="akunito"
IP_Server_ETH="192.168.8.80"
IP_Server_WIFI="192.168.8.81"
SSH_Server="ssh -p 22 -A $server_USER@$IP_Server_ETH"
SSH_Server_2="ssh -p 22 -A $server_USER@$IP_Server_WIFI"
SSH_Server_BOOT="ssh -p 22 root@$IP_Server_ETH"
# ================== NetwServer NetLab
network_USER="akunito"
IP_NetLab_ETH="192.168.8.100"
IP_NetLab_WIFI="192.168.8.101"
SSH_NetLab="ssh -p 22 $network_USER@$IP_NetLab_ETH"
SSH_NetLab_2="ssh -p 22 $network_USER@$IP_NetLab_WIFI"

# ================== My MacBook
IP_MacAku_ETH="192.168.8.90"
IP_MacAku_WIFI="192.168.8.91"
# ================== My Phone
IP_PhoneAku="192.168.8.95"
# ================== Work Laptop
IP_WorkLaptopAku_ETH="192.168.8.97"
# ================== Aga Phone
IP_PhoneAga="192.168.8.75"


# =======================================================================================
# ============================== SSHFS ==================================================
# ================== Laptop Aga
# drive HOME
agalaptop_HOME_ORIGEN="/home/aga"
agalaptop_HOME_DESTINATION="/Users/akunito/Volumes/sshfs/agalaptop_home"
agalaptop_HOME_VOLNAME="agalaptop_home"
agalaptop_HOME_MOUNT="$SSHFS_SH mount normal $agalaptop_USER $IP_LaptopAga_WIFI $IP_LaptopAga_ETH 22 $agalaptop_HOME_ORIGEN $agalaptop_HOME_DESTINATION $agalaptop_HOME_VOLNAME"
agalaptop_HOME_UNMOUNT="$SSHFS_SH unmount normal $agalaptop_USER $IP_LaptopAga_WIFI $IP_LaptopAga_ETH 22 $agalaptop_HOME_ORIGEN $agalaptop_HOME_DESTINATION $agalaptop_HOME_VOLNAME"


# ================== My Router Flint
# drive FS
router_FS_ORIGEN="/"
router_FS_DESTINATION="/Users/akunito/Volumes/sshfs/routerFS"
router_FS_VOLNAME="routerFS"
router_FS_MOUNT="$SSHFS_SH mount normal $router_USER $IP_RouterLAN $IP_RouterWG 22 $router_FS_ORIGEN $router_FS_DESTINATION $router_FS_VOLNAME"
router_FS_UNMOUNT="$SSHFS_SH unmount normal $router_USER $IP_RouterLAN $IP_RouterWG 22 $router_FS_ORIGEN $router_Fs_DESTINATION $router_FS_VOLNAME"

# ================== Server HomeLab
# drive DATA_4TB
server_DATA_4TB_ORIGEN="/mnt/DATA_4TB"
server_DATA_4TB_DESTINATION="/Users/akunito/Volumes/sshfs/Data_4TB"
server_DATA_4TB_VOLNAME="Data_4TB"
server_DATA_4TB_MOUNT="$SSHFS_SH mount normal $server_USER $IP_Server_ETH $IP_Server_WIFI 22 $server_DATA_4TB_ORIGEN $server_DATA_4TB_DESTINATION $server_DATA_4TB_VOLNAME"
server_DATA_4TB_UNMOUNT="$SSHFS_SH unmount normal $server_USER $IP_Server_ETH $IP_Server_WIFI 22 $server_DATA_4TB_ORIGEN $server_DATA_4TB_DESTINATION $server_DATA_4TB_VOLNAME"
# drive HOME
server_HOME_ORIGEN="/home/akunito"
server_HOME_DESTINATION="/Users/akunito/Volumes/sshfs/archaku_home"
server_HOME_VOLNAME="archaku_home"
server_HOME_MOUNT="$SSHFS_SH mount normal $server_USER $IP_Server_ETH $IP_Server_WIFI 22 $server_HOME_ORIGEN $server_HOME_DESTINATION $server_HOME_VOLNAME"
server_HOME_UNMOUNT="$SSHFS_SH unmount normal $server_USER $IP_Server_ETH $IP_Server_WIFI 22 $server_HOME_ORIGEN $server_HOME_DESTINATION $server_HOME_VOLNAME"
# drive Machines
server_MACHINES_ORIGEN="/mnt/Machines"
server_MACHINES_DESTINATION="/Users/akunito/Volumes/sshfs/server_Machines"
server_MACHINES_VOLNAME="server_Machines"
server_MACHINES_MOUNT="$SSHFS_SH mount normal $server_USER $IP_Server_ETH $IP_Server_WIFI 22 $server_MACHINES_ORIGEN $server_MACHINES_DESTINATION $server_MACHINES_VOLNAME"
server_MACHINES_UNMOUNT="$SSHFS_SH unmount normal $server_USER $IP_Server_ETH $IP_Server_WIFI 22 $server_MACHINES_ORIGEN $server_MACHINES_DESTINATION $server_MACHINES_VOLNAME"
# drive MacBookPro_Backups
server_MACAKUBACKUP_ORIGEN="/mnt/DATA_4TB/backups/MacBookPro"
server_MACAKUBACKUP_DESTINATION="/Users/akunito/Volumes/sshfs/MacBookPro_Backups"
server_MACAKUBACKUP_VOLNAME="MacBookPro_Backups"
server_MACAKUBACKUP_ATTACH="/Users/akunito/Volumes/sshfs/MacBookPro_Backups/TimeMachineBackup.sparsebundle"
server_MACAKUBACKUP_MOUNT="$SSHFS_SH mount backup $server_USER $IP_Server_ETH $IP_Server_WIFI 22 $server_MACAKUBACKUP_ORIGEN $server_MACAKUBACKUP_DESTINATION $server_MACAKUBACKUP_VOLNAME $server_MACAKUBACKUP_ATTACH"
server_MACAKUBACKUP_UNMOUNT="$SSHFS_SH unmount backup $server_USER $IP_Server_ETH $IP_Server_WIFI 22 $server_MACAKUBACKUP_ORIGEN $server_MACAKUBACKUP_DESTINATION $server_MACAKUBACKUP_VOLNAME $server_MACAKUBACKUP_ATTACH"

# ================== Server NetLab
# drive HOME
network_HOME_ORIGEN="/home/akunito"
network_HOME_DESTINATION="/Users/akunito/Volumes/sshfs/netlab_home"
network_HOME_VOLNAME="netlab_home"
network_HOME_MOUNT="$SSHFS_SH mount normal $network_USER $IP_NetLab_ETH $IP_NetLab_WIFI 22 $network_HOME_ORIGEN $network_HOME_DESTINATION $network_HOME_VOLNAME"
network_HOME_UNMOUNT="$SSHFS_SH unmount normal $network_USER $IP_NetLab_ETH $IP_NetLab_WIFI 22 $network_HOME_ORIGEN $network_HOME_DESTINATION $network_HOME_VOLNAME"

# =======================================================================================
# ============================== Projects ===============================================
# ================== Laptop Aga
project_LaptopAga_HOME="/Users/akunito/Volumes/sshfs/agalaptop_home"
project_LaptopAga_DOTFILES="/Users/akunito/Volumes/sshfs/agalaptop_home/.dotfiles"

# ================== Server HomeLab
project_ServerHomelab_HOME="/Users/akunito/Volumes/sshfs/archaku_home"
project_ServerHomelab_DOTFILES="/Users/akunito/Volumes/sshfs/archaku_home/.dotfiles"
project_ServerHomelab_HOMELAB="/Users/akunito/Volumes/sshfs/archaku_home/.homelab"

# ================== Server NetLab
project_ServerNetlab_HOME="/Users/akunito/Volumes/sshfs/netlab_home"
project_ServerNetlab_DOTFILES="/Users/akunito/Volumes/sshfs/netlab_home/.dotfiles"
project_ServerNetlab_HOMELAB="/Users/akunito/Volumes/sshfs/netlab_home/.homelab"




# =======================================================================================
# ============================== Associated ARRAYs for each SERVER ======================
# VPN Server configurations
VPN_SSH=("$SSH_VPN")
VPN_DRIVES=()  # Add drives here if any
VPN_PROJECTS=() # Add projects here if any

# Laptop Aga Server configurations
LAPTOP_AGA_SSH=("$SSH_LaptopAga" "$SSH_LaptopAga_2")
LAPTOP_AGA_DRIVES=("$agalaptop_HOME_MOUNT" "$agalaptop_HOME_UNMOUNT")
LAPTOP_AGA_PROJECTS=("$project_LaptopAga_HOME" "$project_LaptopAga_DOTFILES")

# HomeLab Server configurations
HOMELAB_SSH=("$SSH_Server" "$SSH_Server_2" "$SSH_Server_BOOT")
HOMELAB_DRIVES=("$server_DATA_4TB_MOUNT" "$server_HOME_MOUNT" "$server_MACAKUBACKUP_MOUNT")
HOMELAB_PROJECTS=("$project_ServerHomelab_HOME" "$project_ServerHomelab_DOTFILES")

# Lab Server configurations
LAB_SSH=("$SSH_NetLab" "$SSH_NetLab_2")
LAB_DRIVES=("$network_HOME_MOUNT")
LAB_PROJECTS=("$project_ServerNetlab_HOME" "$project_ServerNetlab_DOTFILES")

