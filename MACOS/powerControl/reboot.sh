#!/bin/bash

# Display a dialog box for confirmation
osascript -e 'display dialog "Are you sure you want to restart your Mac?" buttons {"Yes", "No"} default button "No"' -e 'if the button returned of the result is "Yes" then tell app "System Events" to restart'
