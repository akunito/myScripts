mkdir -p ~/Volumes/sshfs/MacBookPro_Backups
sshfs akunito@192.168.0.80:/mnt/DATA_4TB/backups/MacBookPro ~/Volumes/sshfs/MacBookPro_Backups -C -p 22 -o reconnect -o volname=MacBookPro_Backups
sleep 2
hdiutil attach ~/Volumes/sshfs/MacBookPro_Backups/TimeMachineBackup.sparsebundle