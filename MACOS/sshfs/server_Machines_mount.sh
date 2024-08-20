mkdir -p ~/Volumes/sshfs/server_Machines
sshfs akunito@192.168.0.80:/mnt/Machines ~/Volumes/sshfs/server_Machines -C -p 22 -o reconnect -o volname=server_Machines