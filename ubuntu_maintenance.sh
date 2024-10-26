#!/bin/bash

# Log file path
LOG_FILE="/root/scripts/maintenance/maintenance.log"
# Maximum number of old log files to keep
MAX_LOG_FILES=3

# Function to check if log file exceeds 1MB and rotate it
rotate_log() {
    max_size=$((1 * 1024 * 1024)) # 1MB in bytes
    if [ -f "$LOG_FILE" ] && [ $(stat -c%s "$LOG_FILE") -gt $max_size ]; then
        # Rotate the current log file
        mv "$LOG_FILE" "${LOG_FILE}_$(date '+%Y-%m-%d_%H-%M-%S').old"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Log file rotated. A new log file has been created." >> "$LOG_FILE"
        
        # Manage old log files: keep only the last $MAX_LOG_FILES files
        log_count=$(ls -1 "${LOG_FILE}_*.old" 2>/dev/null | wc -l)
        if [ "$log_count" -gt "$MAX_LOG_FILES" ]; then
            # Delete the oldest log files, keep only $MAX_LOG_FILES most recent
            ls -1t "${LOG_FILE}_*.old" | tail -n +$((MAX_LOG_FILES + 1)) | xargs rm -f
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Old log files cleaned up. Kept only the last $MAX_LOG_FILES files." >> "$LOG_FILE"
        fi
    fi
}

# Log function: logs datetime, task, and output
log_task() {
    local task="$1"
    local output

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $task" >> "$LOG_FILE"

    # Run the command and capture its output
    shift
    output=$("$@" 2>&1)

    # Log each line of output with a timestamp and task name
    while IFS= read -r line; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $task | $line" >> "$LOG_FILE"
    done <<< "$output"

    if [ $? -eq 0 ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $task completed successfully." >> "$LOG_FILE"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $task failed." >> "$LOG_FILE"
    fi
}

# Rotate log file if it exceeds 1MB
rotate_log

# Start log
log_task "System maintenance started" echo "Starting system maintenance on $(date)"

# Update package list
log_task "Updating package list" sudo apt update

# Upgrade installed packages
log_task "Upgrading installed packages" sudo apt upgrade -y

# Full upgrade to handle kernel and distribution upgrades
log_task "Performing full upgrade" sudo apt full-upgrade -y

# Remove old packages
log_task "Removing unused packages" sudo apt autoremove -y

# Clean the local repository of retrieved package files
log_task "Cleaning up old packages" sudo apt autoclean

# Remove old kernels, keep the current one
current_kernel=$(uname -r)
old_kernels=$(dpkg -l 'linux-image-[0-9]*' | awk '{print $2}' | grep -v "$current_kernel")

if [ -n "$old_kernels" ]; then
    log_task "Removing old kernels" sudo apt-get purge -y $old_kernels
else
    log_task "Old kernel removal" echo "No old kernels to remove."
fi

# Check if a reboot is required
if [ -f /var/run/reboot-required ]; then
    log_task "Reboot required, rebooting system" sudo reboot
else
    log_task "Reboot check" echo "No reboot required."
fi

# End log
log_task "System maintenance completed" echo "System maintenance completed on $(date)"