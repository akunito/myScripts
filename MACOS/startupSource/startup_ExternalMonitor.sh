#!/bin/bash

before=2.5
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

    manage_space_and_run 10 'open -a "obsidian.app"'
    # manage_space_and_run 9
    # manage_space_and_run 8
    # manage_space_and_run 7
    # manage_space_and_run 6
    # manage_space_and_run 5 'open -a "Chromium.app"'
    # manage_space_and_run 4
    manage_space_and_run 3
    manage_space_and_run 2 "cursor"
    manage_space_and_run 1 'open ~ && open -a "vivaldi.app"'
}

$YABAI_FUNCTIONS_PATH "set_spaces_externalMonitors"
$YABAI_FUNCTIONS_PATH "set_windows_externalMonitors"
call_apps

