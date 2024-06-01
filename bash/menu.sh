#!/bin/bash
# Bash Menu Script Example

# ----------------------------------------------------
# GENERAL TIPS & PATHS
# ----------------------------------------------------
# exec --> $ sudo bash $HOME/mySCRIPTS/menu.sh
# add shortcut --> $ ln -s $HOME/mySCRIPTS/menu.sh /usr/bin/aku
# make it executable --> chmod +x $HOME/mySCRIPTS/menu.sh   
# exec shortcut --> aku

# ----------------------------------------------------
# BEFORE USING THIS SCRIPT -> VPN Section Instructions
# ----------------------------------------------------
# 1 - Create a file in /etc/<yourpassfile>.pass which contains the vpn private key password.
    # first line email
    # second line password
# 2 - Set permission for the file: 'sudo chmod 600 /etc/<yourpassfile>.pass' - Owner can read and write.
# 3 - Create an alias in your .bashrc or bash_profile: alias vpn="sudo sh <path to your script>".
# 4 - Set the value of the variable OVPN_FILE_BASE_PATH with the path of the .ovpn file.
# 5 - Set the value of the variable OVPN_PRIVATE_KEY_FILE_PATH with the path of the created file in step #1: /etc/<yourpassfile>.pass
# 6 - OPTIONAL: avoid  password when executing the script, add this to /etc/sudoers '<your username> ALL=(ALL:ALL) NOPASSWD:<path to your script>'
# 7 - Download ovpn files from NordVPN:
    # sudo wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip
# 8 - install opvn
    # https://fedoraproject.org/wiki/OpenVPN
        # dnf install openvpn
    # OR in Ubuntu~
        # apt install openvpn
# 

# VPN VARIABLES
OVPN_BASE_PATH=/home/akunito/ovpn_nordvpn/ovpn_udp/ # string must finish with /
OVPN_PRIVATE_KEY_FILE_PATH='/etc/nordvpn.pass' # sudo subl /etc/nordvpn.pass y actualizar

# DOCKER VARIABLES
DOCKER_SHARE=/mnt/Linux_Data/Docker_Share/


choose_vpn(){
    # ask to user to provide Country and Server to connect
    # feeds start_vpn function with inputs
    clear
    echo "Please enter 'Country' ['pl' 'es' 'de' ...] "
    read country
    cd $OVPN_BASE_PATH
    ls $country*

    echo -e "\nPlease enter 'number' [if '$country 125' >> '125'] "
    read number

    start_vpn $country $number
}
-

start_vpn(){   
    echo -e "\nConnecting to $country$number (to disconnect press CTRL+C)"
    OVPN_FILE_PATH=$OVPN_BASE_PATH$country$number.nordvpn.com.udp.ovpn #check that the file name is correct
    #sudo nohup openvpn --config $OVPN_FILE_PATH --auth-user-pass $OVPN_PRIVATE_KEY_FILE_PATH --auth-nocache \
    sudo openvpn --config $OVPN_FILE_PATH --auth-user-pass $OVPN_PRIVATE_KEY_FILE_PATH --auth-nocache \
      #--script-security 2 \
      #--setenv PATH '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
      #--up /etc/openvpn/scripts/update-systemd-resolved \
      #--down /etc/openvpn/scripts/update-systemd-resolved \
      #--down-pre \
      #&>/dev/null &
    echo 'Disconnected!'
    export DISPLAY=:0.0
    notify-send "Connected to VPN!"
}


main(){
    # show user menu
    clear
    PS3='Please enter your choice: '
    options=("Backup manager" "Phone manager" "Update Arch" "systemctl manager" "sensors manager" "Connect VPN" "Onedrive sync" "open postgresql console" "BalenaEtcher - Flash ISOs" "systemd options (startup)" "Open GIT directory" "docker menu" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Backup manager")
                clear
                PS3='Please enter your choice: '
                options=("save Browser data" "save my DotFiles" "save Root files" "Clean Browser only !" "Clean DotFiles only !" "Clean ALL ConfigBackups !!" "Quit")
                select opt in "${options[@]}"
                do
                    case $opt in
                        "save Browser data")
                            clear
                            sudo ~/mySCRIPTS/backBrowsers.sh
                            ;;

                        "save my DotFiles")
                            clear
                            sudo ~/mySCRIPTS/backDotfiles.sh
                            ;;

                        "save Root files")
                            clear
                            sudo ~/mySCRIPTS/backRootFiles.sh
                            ;;

                        "Clean Browser only !")
                            clear
                            sudo rm -R /mnt/TimeShift/ConfigBackups/browsersDotfiles
                            ;;

                        "Clean DotFiles only !")
                            clear
                            sudo rm -R /mnt/TimeShift/ConfigBackups/homeDotfiles
                            ;;

                        "Clean ALL ConfigBackups !!")
                            clear
                            sudo rm -R /mnt/TimeShift/ConfigBackups
                            ;;

                        "Quit")
                            clear
                            break
                            ;;
                        *) echo "invalid option $REPLY";;
                    esac
                done
                ;;

            "Phone manager")
                clear
                PS3='Please enter your choice: '
                options=("phone media" "remove old phone media" "Quit")
                select opt in "${options[@]}"
                do
                    case $opt in
                        "phone media")
                            clear
                            sudo ~/mySCRIPTS/phoneBackup.sh
                            ;;

                        "remove old phone media")
                            clear
                            sudo ~/mySCRIPTS/backDotfiles.sh
                            ;;

                        "Quit")
                            clear
                            break
                            ;;
                        *) echo "invalid option $REPLY";;
                    esac
                done
                ;;

            "Update Arch")
                clear
                PS3='Please enter your choice: '
                options=("ALL Up&Clean" "Pacman Up&Clean" "Yay Up&Clean" "Aura Up&Clean" "Flatpak Up&Clean" "Quit")
                select opt in "${options[@]}"
                do
                    case $opt in
                        "ALL Up&Clean")
                            clear
                            sudo pacman -Sy archlinux-keyring
                            sudo pacman -Syu
                            sudo pacman -Scc
                            yay -Yc
                            yay
                            sudo aura --orphans --abandon
                            sudo aura --sync --refresh --sysupgrade
                            sudo aura --aursync --diff --sysupgrade --delmakedeps --unsuppress
                            flatpak remove --unused
                            flatpak update
                            ;;

                        "Pacman Up&Clean")
                            clear
                            sudo pacman -Sy archlinux-keyring
                            sudo pacman -Syu
                            sudo pacman -Scc
                            ;;

                        "Yay Up&Clean")
                            clear
                            yay -Yc
                            yay
                            ;;

                        "Aura Up&Clean")
                            clear
                            sudo aura --orphans --abandon
                            sudo aura --sync --refresh --sysupgrade
                            sudo aura --aursync --diff --sysupgrade --delmakedeps --unsuppress
                            ;;

                        "Flatpak Up&Clean")
                            clear
                            flatpak remove --unused
                            flatpak update
                            ;;
                        "Quit")
                            clear
                            break
                            ;;
                        *) echo "invalid option $REPLY";;
                    esac
                done
                ;;


            "systemctl manager")
                clear
                PS3='Please enter your choice: '
                options=("systemd-analyze blame" "start docker" "start libvirtd (VMs)" "Quit")
                select opt in "${options[@]}"
                do
                    case $opt in
                        "start postgresql service (systemctl)")
                            clear
                            echo "you chose '$opt'"
                            systemctl start postgresql
                            ;;

                        "start docker")
                            clear
                            echo "you chose '$opt'"
                            systemctl --user start docker-desktop
                            ;;

                        "start libvirtd (VMs)")
                            clear
                            echo "you chose '$opt'"
                            echo "starting libvirtd service"
                            systemctl start libvirtd.service
                            #sudo virsh net-autostart default (autostart set by command?)
                            ;;

                        "Quit")
                            clear
                            break
                            ;;
                        *) echo "invalid option $REPLY";;
                    esac
                done
                ;;


            "sensors manager")
                clear
                PS3='Please enter your choice: '
                options=("Temperatures" "General consumption (CPU)" "Nvidia consumption" "Quit")
                select opt in "${options[@]}"
                do
                    case $opt in
                        "Temperatures")
                            clear
                            sensors
                            ;;

                        "General consumption (CPU)")
                            clear
                            sudo powerstat -cDHRf 2
                            ;;

                        "Nvidia consumption")
                            clear
                            nvidia-smi
                            ;;

                        "Quit")
                            clear
                            break
                            ;;
                        *) echo "invalid option $REPLY";;
                    esac
                done
                ;;

            "Connect VPN")
                clear
                echo "you chose '$opt'"

                choose_vpn            
                ;;

            "Onedrive sync")
                clear
                echo "you chose '$opt'"
                onedrive --synchronize
                ;;

            "open postgresql console")
                clear
                echo "you chose '$opt'"
                sudo sudo -u postgres psql
                ;;
                

            "BalenaEtcher - Flash ISOs")
                clear
                echo "if no permissions use '$chmod u+x  balenaEtcher-Version.AppImage'"
                echo "if different version, update this script or use ./filename"
                echo "to execute use: './balenaEtcher-Version.AppImage' "
                echo "download in the official web if not found in ~"
                pwd
                ./balenaEtcher-1.10.2-x64.AppImage
                ;;

            "systemd options (startup)")
                clear
                PS3='Please enter your choice: '
                options=("systemd-analyze blame" "stop annecesary services" "start annecesary services" "Quit")
                select opt in "${options[@]}"
                do
                    case $opt in
                        "systemd-analyze blame")
                            clear
                            systemd-analyze blame >> ~/mySCRIPTS/systemd-analyze.txt
                            echo "opening results by bat"
                            nano ~/mySCRIPTS/systemd-analyze.txt
                            echo "general results are following ->"
                            systemd-analyze
                            ;;

                        "stop annecesary services")
                            clear
                            echo "work in progress"
                            ;;

                        "start annecesary services")
                            clear
                            echo "work in progress"
                            ;;


                        "Quit")
                            clear
                            break
                            ;;
                        *) echo "invalid option $REPLY";;
                    esac
                done
                ;;

            "Open GIT directory")
                clear
                echo "opening git directory in other Alacritty window"
                alacritty --working-directory /mnt/Ubuntu_Data/'CODE_&_PROJECTS'/git_repos
                ;;

            "docker menu")
                clear
                PS3='Please enter your choice: '
                options=("start docker" "log into sql1" "start sql1" "start ubuntu_dev" "save ubuntu_dev status" "remove images" "list images" "list containers" "Quit")
                select opt in "${options[@]}"
                do
                    case $opt in
                        "start docker")
                            clear
                            echo ""
                            echo "REMEMBER: to create a new image to save the container status, use next command:"
                            echo "sudo docker commit -p container_id new_container_name"
                            echo "sudo docker commit -p 524aa76baafb my_ubuntu_20.04_dev2"
                            echo "more info here https://www.makeuseof.com/run-ubuntu-as-docker-container/"
                            echo ""
                            echo "starting docker services..."
                            sudo systemctl start docker
                            echo "ready"
                            ;;


                        "log into sql1")
                            clear
                            echo ""
                            echo "running sql server 'sql1'..."
                            sleep 2
                            sudo docker exec -it sql1 "bash"
                            ;;


                        "start sql1")
                            clear
                            echo ""
                            echo "running sql server 'sql1'..."
                            sleep 2
                            sudo docker start sql1
                            ;;
                            
                            
                        "start ubuntu_dev")
                            clear
                            echo ""
                            echo "running docker with persisting data directory..."
                            echo "from: "$DOCKER_SHARE
                            echo "to:   /data"
                            echo ""
                            sleep 2
                            #command without persistency: sudo docker run -ti --rm ubuntu_dev
                            # with persistency: sudo docker run -ti --rm -v $DOCKER_SHARE:/data ubuntu_dev
                            sudo docker run -ti -v $DOCKER_SHARE:/data ubuntu_dev
                            ;;

                        "save ubuntu_dev status")
                            clear
                            echo ""
                            sudo docker ps
                            echo ""
                            echo "Please enter 'container id to be SAVED' "
                            read container_id
                            echo "Saving "$container_id" status to ubuntu_dev...."
                            sudo docker commit -p $container_id ubuntu_dev
                            echo "loading ..."
                            sleep 5
                            echo ""
                            sudo docker image ls
                            echo ""
                            echo "loading ..."
                            sleep 5
                            echo "uploading the new image ubuntu_dev to /mnt/Backups_External/docker_backups/"
                            sudo docker save --output /mnt/Backups_External/docker_backups/ubuntu_dev.tar ubuntu_dev
                            echo "-------"
                            echo "if you see an error, copy the last command and run it again"
                            echo "sudo docker save --output /mnt/Backups_External/docker_backups/ubuntu_dev.tar ubuntu_dev"
                            echo "----END"
                            ;;
                        
                        "remove images")
                            clear
                            echo ""
                            sudo docker image ls
                            echo ""
                            echo "Please enter 'container id to be >> REMOVED <<' "
                            read container_id
                            echo "Saving "$container_id" status to ubuntu_dev...."
                            sudo docker image rm $container_id
                            echo "removing ..."
                            sleep 5
                            echo ""
                            sudo docker image ls
                            echo ""
                            ;;

                        "list images")
                            clear
                            sudo docker image ls
                            ;;

                        "list containers")
                            clear
                            sudo docker container ls
                            echo ""
                            echo "remember that to start as user in a container you can use:"
                            echo "sudo docker exec -it container_name_or_id su - user"
                            echo ""
                            ;;

                        "Quit")
                            clear
                            break
                            ;;
                        *) echo "invalid option $REPLY";;
                    esac
                done
                ;;

            "Quit")
                clear
                break
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done

}

# startup script
echo "Welcome $HOME"
main
