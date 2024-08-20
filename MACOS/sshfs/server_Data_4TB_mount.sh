mkdir -p ~/Volumes/sshfs/Data_4TB
sshfs akunito@192.168.0.80:/mnt/DATA_4TB ~/Volumes/sshfs/Data_4TB -C -p 22 -o reconnect -o volname=Data_4TB