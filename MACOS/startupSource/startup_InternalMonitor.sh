#!/bin/bash

before=1
after=1

# focus Space 1 and open apps
sleep $before && skhd -k "ctrl + alt + cmd - 1" && sleep $after
open -a 'obsidian.app'

# focus Space 2 and open apps
sleep $before && skhd -k "ctrl + alt + cmd - 2" && sleep $after
open -a 'vivaldi.app'

# focus Space 3 and open apps
sleep $before && skhd -k "ctrl + alt + cmd - 3" && sleep $after
open -a 'Visual Studio Code.app'

# focus Space 4 and open apps
sleep $before && skhd -k "ctrl + alt + cmd - 4" && sleep $after
open ~ # Open HOME on Finder

# focus Space 5 and open apps
# sleep $before && skhd -k "ctrl + alt + cmd - 5" && sleep $after

# focus Space 6 and open apps
# sleep $before && skhd -k "ctrl + alt + cmd - 6" && sleep $after

# focus Space 7 and open apps
sleep $before && skhd -k "ctrl + alt + cmd - 7" && sleep $after
open -a 'Chromium.app'
open -a 'Spotify.app'

# focus Space 8 and open apps
# sleep $before && skhd -k "ctrl + alt + cmd - 8" && sleep $after
