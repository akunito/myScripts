mkdir -p ~/Volumes/sshfs/archaku_home
sshfs akunito@192.168.0.80:/home/akunito ~/Volumes/sshfs/archaku_home -C -p 22 -o reconnect -o volname=archaku_home