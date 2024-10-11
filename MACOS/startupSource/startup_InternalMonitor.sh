#!/bin/bash

# # include VARIABLES.sh
# source $VARIABLES_PATH
# echo "sourcing $VARIABLES_PATH"

before=2
after=1.5

call_apps() {
    echo "call_apps"
    # focus Space 8 and open apps
    # sleep $before && skhd -k "ctrl + alt + cmd - 8" && sleep $after

    # focus Space 7 and open apps
    # sleep $before && skhd -k "ctrl + alt + cmd - 7" && sleep $after
    # open -a 'Chromium.app'

    # focus Space 6 and open apps
    # sleep $before && skhd -k "ctrl + alt + cmd - 6" && sleep $after

    # focus Space 5 and open apps
    sleep $before && skhd -k "ctrl + alt + cmd - 5" && sleep $after
    open ~ # Open HOME on Finder

    # focus Space 4 and open apps
    sleep $before && skhd -k "ctrl + alt + cmd - 4" && sleep $after
    code /Users/akunito/syncthing/git_repos/myProjects/KeyboardProjects/spinachShortcuts

    # focus Space 3 and open apps
    sleep $before && skhd -k "ctrl + alt + cmd - 3" && sleep $after
    # open -a 'Visual Studio Code.app'
    code /Users/akunito/syncthing

    # focus Space 2 and open apps
    sleep $before && skhd -k "ctrl + alt + cmd - 2" && sleep $after
    open -a 'vivaldi.app'

    # focus Space 1 and open apps
    # sleep $before && skhd -k "ctrl + alt + cmd - 1" && sleep $after
    open -a 'obsidian.app'
    skhd -k "ctrl + alt + cmd - 1"
}

$YABAI_FUNCTIONS_PATH "set_spaces_singleMonitor"
$YABAI_FUNCTIONS_PATH "set_windows_singleMonitors"
call_apps