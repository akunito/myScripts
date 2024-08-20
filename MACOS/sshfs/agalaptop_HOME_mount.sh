mkdir -p ~/Volumes/sshfs/agalaptop_home
sshfs aga@192.168.0.78:/home/aga ~/Volumes/sshfs/agalaptop_home -C -p 22 -o reconnect -o volname=agalaptop_home