#!/bin/sh

# Script to rotate the .log file located at the given path

create_file() {
    local file_path="$1"
    local directory=$(dirname "$file_path")
    mkdir -p "$directory"
    touch "$file_path"
}

# Function to check if log file exceeds 10MB and rotate it
rotate_log() {
    local log_file="$1"
    local MAX_log_fileS="3"
    max_size=$((10 * 1024 * 1024)) # 10MB in bytes
    create_file "$log_file"
    
    # Detect OS and use appropriate stat command
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        file_size=$(stat -f%z "$log_file")
    else
        # Linux and others
        file_size=$(stat -c%s "$log_file")
    fi

    if [ "$file_size" -gt "$max_size" ]; then
        # Rotate the current log file
        mv "$log_file" "${log_file}_$(date '+%Y-%m-%d_%H-%M-%S').old"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Log file rotated. A new log file has been created." >> "$log_file"
        
        # Manage old log files: keep only the last $MAX_log_fileS files
        log_count=$(ls -1 "${log_file}_*.old" 2>/dev/null | wc -l)
        if [ "$log_count" -gt "$MAX_log_fileS" ]; then
            # Delete the oldest log files, keep only $MAX_log_fileS most recent
            ls -1t "${log_file}_*.old" | tail -n +$((MAX_log_fileS + 1)) | xargs rm -f
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Old log files cleaned up. Kept only the last $MAX_log_fileS files." >> "$log_file"
        fi
    fi
}

rotate_log "$HOME/maintenance.log"