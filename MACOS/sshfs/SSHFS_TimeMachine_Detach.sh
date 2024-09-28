#!/bin/bash

# Define the location of the sparsebundle (you may need to change this)
DESTINATION="$1"
ATTACHMENT="$2"

# 1. Check if the sparsebundle is currently in use by Time Machine
echo "Checking if Time Machine is currently backing up..."
tmutil status | grep "BackupPhase" >/dev/null

if [ $? -eq 0 ]; then
    echo "A Time Machine backup is in progress. Please wait until it completes before unmounting."
    exit 1
fi

# 2. Detach the sparsebundle safely
echo "Unmounting the sparsebundle..."
hdiutil detach "$ATTACHMENT"

if [ $? -ne 0 ]; then
    echo "Failed to unmount the sparsebundle. Make sure it's not in use."
    exit 1
fi

echo "Sparsebundle successfully unmounted."

# 3. Eject the network volume if necessary (Optional step, for network drives)
if mount | grep "$DESTINATION" >/dev/null; then
    echo "Ejecting the network volume..."
    diskutil unmount "$DESTINATION"

    if [ $? -ne 0 ]; then
        echo "Failed to eject the network volume."
        exit 1
    else
        echo "Network volume successfully ejected."
    fi
fi

echo "Unmounting process complete."
exit 0
