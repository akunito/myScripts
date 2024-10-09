#!/bin/bash

# # include VARIABLES.sh
# source $VARIABLES_PATH
# echo "sourcing $VARIABLES_PATH"

before=2.5
after=1.5

set_spaces_externalMonitors() {
    echo "set_spaces"
    
    # Bind Spaces to Display 1
    for i in {1..6}; do
        yabai -m space "$i" --display 1
    done

    # Bind Spaces to Display 2
    for i in {7..9}; do
        yabai -m space "$i" --display 2
    done

    # Bind Spaces to Display 3
    for i in {10..12}; do
        yabai -m space "$i" --display 3
    done

    # set the window rules
    # yabai -m rule --add app="^Obsidian$" display=2 # ????????? TODO
    yabai -m rule --add app="^Vivaldi$" space=1
}

set_windows_externalMonitors() {
    echo "set_windows"
    # set Kitty Grid
    yabai -m window $(yabai -m query --windows | jq ".[] | select(.app == \"kitty\").id") --grid 20:20:10:1:10:16
    # set qBittorrent Grid
    # yabai -m window $(yabai -m query --windows | jq ".[] | select(.app == \"qBittorrent\").id") --grid 10:10:5:0:5:5
}

call_apps() {
    echo "call_apps"
    # focus Space 8 and open apps
    # sleep $before && skhd -k "ctrl + alt + cmd - 8" && sleep $after

    # focus Space 7 and open apps
    # sleep $before && skhd -k "ctrl + alt + cmd - 7" && sleep $after

    # focus Space 6 and open apps
    # sleep $before && skhd -k "ctrl + alt + cmd - 6" && sleep $after

    # focus Space 5 and open apps
    sleep $before && skhd -k "ctrl + alt + cmd - 5" && sleep $after
    open -a 'Chromium.app'

    # focus Space 4 and open apps
    sleep $before && skhd -k "ctrl + alt + cmd - 4" && sleep $after
    code /Users/akunito/Volumes/sshfs/archaku_home

    # focus Space 3 and open apps
    sleep $before && skhd -k "ctrl + alt + cmd - 3" && sleep $after
    code /Users/akunito/syncthing/git_repos/myProjects/KeyboardProjects/spinachShortcuts

    # focus Space 2 and open apps
    sleep $before && skhd -k "ctrl + alt + cmd - 2" && sleep $after
    code /Users/akunito/syncthing

    # focus Space 1 and open apps
    sleep $before && skhd -k "ctrl + alt + cmd - 1" && sleep $after
    open ~ # Open HOME on Finder
    open -a 'vivaldi.app'
    open -a 'obsidian.app'
}

set_spaces_externalMonitors
set_windows_externalMonitors
call_apps

