#!/bin/bash

SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")

APP_NAME="kitty"
LOG_FILE="$SELF_PATH/yabai_functions.log"

echo "=================================================================" >> "$LOG_FILE"
yabai -m query --windows | jq ".[] | select(.app == \"$APP_NAME\").id" >> "$LOG_FILE"
echo "=====" >> "$LOG_FILE"

# Generate a unique run ID for each execution
RUN_ID=$(date +%s%N)

# Get the current timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Get the window ID of the app
APP_WINDOW_ID=$(yabai -m query --windows | jq ".[] | select(.app == \"$APP_NAME\").id")

# Get the currently focused window ID
FOCUSED_WINDOW_ID=$(yabai -m query --windows --window | jq ".id")

# Log function
log_message() {
    echo "[$TIMESTAMP] [RUN_ID: $RUN_ID] $1" >> "$LOG_FILE"
}

# Log the initial variables
log_message "Attempting to toggle app:" "$APP_NAME"
log_message "APP_WINDOW_ID:" "$APP_WINDOW_ID"
log_message "FOCUSED_WINDOW_ID:" "$FOCUSED_WINDOW_ID"

# Check if the app is already focused
if [ "$APP_WINDOW_ID" == "$FOCUSED_WINDOW_ID" ]; then
    # Hide the app if it is focused
    skhd -k "cmd - h"
    log_message "App $APP_NAME is focused, hiding it."
else
    # Focus the app if it is not focused
    yabai -m window --focus "$APP_WINDOW_ID"
    # open /Applications/$APP_NAME.app
    log_message "App $APP_NAME is not focused, focusing it."
fi

# Final log entry for completion
log_message "Action complete."

# toggle kitty
hyper - return : if [ $(yabai -m query --windows  --window | jq  '.app') = '"kitty"' ]; 
    then skhd -k "cmd - h" ; 
    else open /Applications/kitty.app; fi