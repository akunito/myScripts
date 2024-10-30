#!/bin/bash

before=2
after=1.5

# Function to manage space and execute command
manage_space_and_run() {
    local space_number=$1
    local command=$2

    sleep $before && $YABAI_FUNCTIONS_PATH "space_management" $space_number && sleep $after
    if [ -n "$command" ]; then
        eval "$command"
    fi
}

call_apps() {
    echo "call_apps"

    # manage_space_and_run 8
    # manage_space_and_run 7 'open -a "Chromium.app"'
    # manage_space_and_run 6
    manage_space_and_run 5 'open ~'
    # manage_space_and_run 4
    manage_space_and_run 3 "cursor"
    manage_space_and_run 2 'open -a "vivaldi.app"'
    manage_space_and_run 1 'open -a "obsidian.app"'
}

$YABAI_FUNCTIONS_PATH "set_spaces_singleMonitor"
$YABAI_FUNCTIONS_PATH "set_windows_singleMonitors"
call_apps