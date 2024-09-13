mkdir -p ~/Volumes/sshfs/netlab_home
sshfs akunito@192.168.0.100:/home/akunito ~/Volumes/sshfs/netlab_home -C -p 22 -o reconnect -o volname=netlab_home