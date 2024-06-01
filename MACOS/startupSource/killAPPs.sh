#!/bin/bash

# quit all the apps
osascript -e 'tell app "Vivaldi" to quit'
osascript -e 'tell app "Obsidian" to quit'
osascript -e 'tell app "Terminal" to quit'
osascript -e 'tell app "Spotify" to quit'
osascript -e 'tell app "Chromium" to quit'
osascript -e 'tell app "Visual Studio Code" to quit'
osascript -e 'tell app "Activity Monitor" to quit'
osascript -e 'tell app "System Settings" to quit'
osascript -e 'tell app "Finder" to quit'
osascript -e 'tell app "Alacritty" to quit'
osascript -e 'tell app "Karabiner-Elements" to quit'
osascript -e 'tell app "Karabiner-EventViewer" to quit'
# osascript -e 'tell app "kitty" to quit'

echo "Apps have been killed bloodly.. "
