#!/bin/bash

# Get the output of system_profiler SPDisplaysDataType
output=$(system_profiler SPDisplaysDataType)

# Count the number of occurrences of "Display Type: LCD"
# Each occurrence represents a connected monitor
count_all_monitor=$(echo "$output" | grep -c "Online: Yes")
count_internal_monitor=$(echo "$output" | grep -c "Connection Type: Internal")

# Subtract 1 from the count to exclude the internal display
external_monitor_count=$((count_all_monitor - count_internal_monitor))

# Print the number of external monitors
echo "Number of external monitors: $external_monitor_count"
