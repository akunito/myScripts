#!/bin/bash

# Use AppleScript to create the dialog
result=$(osascript -e 'display dialog "What do you want to do?" buttons {"Sleep", "Reboot", "Shut Down"} default button 1 giving up after 5')

# Perform the action based on the user's choice
case $result in
  "button returned:Sleep, gave up:false")
    # Put the system to sleep
    osascript -e 'tell application "System Events" to sleep'
    ;;
  "button returned:Reboot, gave up:false")
    # Reboot the system
    osascript -e 'tell application "System Events" to restart'
    ;;
  "button returned:Shut Down, gave up:false")
    # Shut down the system
    osascript -e 'tell application "System Events" to shut down'
    ;;
esac
