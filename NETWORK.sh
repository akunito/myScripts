#!/bin/bash

# ========================
# IP addresses ===========
IP_LaptopAga_ETH="192.168.8.77"
IP_LaptopAga_WIFI="192.168.8.78"
IP_Server_ETH="192.168.8.80"
IP_Server_WIFI="192.168.8.81"
IP_MacAku_ETH="192.168.8.90"
IP_MacAku_WIFI="192.168.8.91"
IP_PhoneAku="192.168.8.95"
IP_WorkLaptopAku_ETH="192.168.8.97"
IP_NetLab_ETH="192.168.8.100"
IP_NetLab_WIFI="192.168.8.101"


# ========================
# SSHFS ===================
# Server HomeLab
server_USER="akunito"

server_DATA_4TB_ORIGEN="/mnt/DATA_4TB"
server_DATA_4TB_DESTINATION="~/Volumes/sshfs/Data_4TB"
server_DATA_4TB_VOLNAME="Data_4TB"

server_HOME_ORIGEN="/home/akunito"
server_HOME_DESTINATION="~/Volumes/sshfs/archaku_home"
server_HOME_VOLNAME="archaku_home"

server_MACHINES_ORIGEN="/mnt/Machines"
server_MACHINES_DESTINATION="~/Volumes/sshfs/server_Machines"
server_MACHINES_VOLNAME="server_Machines"

server_MACAKUBACKUP_ORIGEN="/mnt/DATA_4TB/backups/MacBookPro"
server_MACAKUBACKUP_DESTINATION="~/Volumes/sshfs/MacBookPro_Backups"
server_MACAKUBACKUP_VOLNAME="MacBookPro_Backups"
server_MACAKUBACKUP_ATTACH="~/Volumes/sshfs/MacBookPro_Backups/TimeMachineBackup.sparsebundle"

# NetLab
network_USER="akunito"

network_HOME_ORIGEN="/home/akunito"
network_HOME_DESTINATION="~/Volumes/sshfs/netlab_home"
network_HOME_VOLNAME="netlab_home"

# Agalaptop
agalaptop_USER="aga"

agalaptop_HOME_ORIGEN="/home/aga"
agalaptop_HOME_DESTINATION="~/Volumes/sshfs/agalaptop_home"
agalaptop_HOME_VOLNAME="agalaptop_home"

