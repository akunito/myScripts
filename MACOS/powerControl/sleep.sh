#!/bin/bash

# Display a dialog box for confirmation
osascript -e 'display dialog "Are you sure you want to put your Mac to sleep?" buttons {"Yes", "No"} default button "No"' -e 'if the button returned of the result is "Yes" then tell app "System Events" to sleep'
