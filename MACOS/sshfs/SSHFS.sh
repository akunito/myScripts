#!/bin/bash

SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
ACTION="$1"
TYPE="$2"
USER="$3"
IP="$4"
IP2="$5"
PORT="$6"
SOURCE="$7"
DESTINATION="$8"
VOLUME_NAME="$9"
ATTACHMENT="${10}"

# Function to check if a host is reachable
check_host() {
    local ip="$1"
    local attempts=3  # Increased the number of attempts for reliability
    local success=1

    echo "Pinging host $ip..."
    for ((i = 1; i <= attempts; i++)); do
        if ping -c 3 -W 1 "$ip" >/dev/null 2>&1; then
            echo "Host $ip is reachable."
            success=0
            break
        else
            echo "Attempt $i: Host $ip is unreachable, retrying..."
            sleep 2
        fi
    done

    return $success
}

# Function to mount the disk
mount_disk() {
    local ip="$1"
    echo "Attempting to mount $VOLUME_NAME at $DESTINATION using IP: $ip"
    
    # Check if $DESTINATION is already mounted
    if mount | grep -q "$DESTINATION"; then
        # Check if the drive responds to ls command, if not, unmount it
        if ! ls "$DESTINATION" > /dev/null 2>&1; then
            echo "$DESTINATION is already mounted but not responding. Unmounting..."
            diskutil unmount force "$DESTINATION" || { echo "Error unmounting $DESTINATION"; return 1; }
        else
            echo "$DESTINATION is already mounted and responding. Skipping re mount."
        fi
    fi

    # Create directory if it doesn't exist
    mkdir -p "$DESTINATION" || { echo "Error creating directory $DESTINATION"; return 1; }

    # Try to mount the disk
    sshfs "$USER@$ip:$SOURCE" "$DESTINATION" -C -p "$PORT" -o reconnect -o volname="$VOLUME_NAME"
    if mount | grep -q "$DESTINATION"; then
        echo "Mount successful: $VOLUME_NAME is mounted at $DESTINATION using IP: $ip"
    else
        echo "Mount failed: Unable to mount $VOLUME_NAME at $DESTINATION using IP: $ip"
        return 1
    fi
}

# Function to handle mounting process with fallback IP
attempt_mount() {
    if check_host "$IP"; then
        mount_disk "$IP"
    elif check_host "$IP2"; then
        echo "Trying with the second IP: $IP2"
        mount_disk "$IP2"
    else
        echo "Both $IP and $IP2 are unreachable. Mount failed."
        return 1
    fi
}

# Main logic
case $ACTION in
    "mount")
        case $TYPE in
            "normal")
                attempt_mount || exit 1
            ;;
            "backup")
                echo "Mounting $VOLUME_NAME for backup"
                attempt_mount || exit 1
                sleep 2
                hdiutil attach "$ATTACHMENT" || { echo "Failed to attach $ATTACHMENT"; exit 1; }
            ;;
        esac
    ;;
    "unmount")
        case $TYPE in
            "normal")
                echo "Unmounting $VOLUME_NAME"
                diskutil unmount force "$DESTINATION" || { echo "Error unmounting $DESTINATION"; exit 1; }
            ;;
            "backup")
                echo "Unmounting $VOLUME_NAME and detaching backup"
                diskutil unmount force "$DESTINATION" || { echo "Error unmounting $DESTINATION"; exit 1; }
                hdiutil detach "$ATTACHMENT" || { echo "Error detaching $ATTACHMENT"; exit 1; }
            ;;
        esac
    ;;
    *)
        echo "Invalid action specified."
        exit 1
    ;;
esac
