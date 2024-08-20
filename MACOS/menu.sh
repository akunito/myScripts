#!/bin/bash
# Bash Menu Script Example

# include VARIABLES.sh
SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/VARIABLES.sh


main(){
    # show user menu
    clear
    PS3='Please enter your choice: '
    options=("Update System" "sshfs" "compress PICS" "virsh manager" "docker menu" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Update System")
                clear
                PS3='Please enter your choice: '
                options=("ALL Up&Clean" "Quit")
                select opt in "${options[@]}"
                do
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
                        *) echo "invalid option $REPLY";;
                    esac
                done
                ;;

            "sshfs")
                clear
                PS3='Please enter your choice: '
                options=("myserver" "agalaptop" "Quit")
                select opt in "${options[@]}"
                do
                    case $opt in

                        "myserver")
                            clear
                            PS3='Please enter your choice: '
                            options=("mount MacBookPro_BACKUPS" "unmount MacBookPro_BACKUPS" "mount Data_4TB" "unmount Data_4TB" "mount server home" "unmount server home" "mount server Machines" "unmount server Machines" "Quit")
                            select opt in "${options[@]}"
                            do
                                case $opt in
                                    "mount MacBookPro_BACKUPS")
                                        clear
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/Mac_backups_unmount.sh
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/Mac_backups_mount.sh
                                        ;;

                                    "unmount MacBookPro_BACKUPS")
                                        clear
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/Mac_backups_unmount.sh
                                        ;;

                                    "mount Data_4TB")
                                        clear
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/server_Data_4TB_unmount.sh
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/server_Data_4TB_mount.sh
                                        ;;

                                    "unmount Data_4TB")
                                        clear
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/server_Data_4TB_unmount.sh
                                        ;;

                                    "mount server home")
                                        clear
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/server_Home_unmount.sh
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/server_Home_mount.sh
                                        ;;

                                    "unmount server home")
                                        clear
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/server_Home_unmount.sh
                                        ;;

                                    "mount server Machines")
                                        clear
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/server_Machines_unmount.sh
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/server_Machines_mount.sh
                                        ;;

                                    "unmount server Machines")
                                        clear
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/server_Machines_unmount.sh
                                        ;;

                                    "Quit")
                                        clear
                                        break
                                        ;;
                                    *) echo "invalid option $REPLY";;
                                esac
                            done
                            ;;

                        "agalaptop")
                            clear
                            PS3='Please enter your choice: '
                            options=("mount agalaptop_HOME" "unmount agalaptop_HOME" "Quit")
                            select opt in "${options[@]}"
                            do
                                case $opt in
                                    "mount agalaptop_HOME")
                                        clear
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/agalaptop_HOME_unmount.sh
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/agalaptop_HOME_mount.sh
                                        ;;

                                    "unmount agalaptop_HOME")
                                        clear
                                        ~/syncthing/git_repos/mySCRIPTS/MACOS/sshfs/agalaptop_HOME_unmount.sh
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
                ;;

            "compress PICS")
                clear
                PS3='Please enter your choice: '
                options=("Obsidian/*.PNG" "Quit")
                select opt in "${options[@]}"
                do
                    case $opt in
                        "Obsidian/*.PNG")
                            clear
                            ~/syncthing/git_repos/mySCRIPTS/MACOS/functions/compressPNGobsidian.sh
                            ;;

                        "Quit")
                            clear
                            break
                            ;;
                        *) echo "invalid option $REPLY";;
                    esac
                done
                ;;

            "virsh manager")
                clear
                PS3='Please enter your choice: '
                options=("Start default network" "Start nm-bridge network" "Quit")
                select opt in "${options[@]}"
                do
                    case $opt in
                        "Start default network")
                            clear
                            virsh net-start default
                            ;;

                        "Start nm-bridge network")
                            clear
                            virsh net-start nm-bridge
                            sudo ip link add nm-bridge type bridge
                            sudo ip address ad dev nm-bridge 192.168.0.0/24
                            sudo ip link set dev nm-bridge up
                            ;;

                        "Quit")
                            clear
                            break
                            ;;
                        *) echo "invalid option $REPLY";;
                    esac
                done
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
